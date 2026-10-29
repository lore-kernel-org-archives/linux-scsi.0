Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239394;
	b=T/+Ov8qOll8epBLtzJO+z668akYyl/tzlV6/M9loQ6wWkLgSAoSPlLi0mTmtwDtuvXDp
	 Oqj5WttbLZOSTPuwGAM5PqVPMq2NP2sFtHNr6qy7kiVQa+cMvnLf0oEPpgmRRN8RC7fZy
	 wkNSp5QBscGBH1pZKSJNOIMCWb+mhsu8aKrIKEZEWMPWNcP6PY/QDu6u7asxrMuhCNL6S
	 PggPbldyCCrodxlq4ih+CVFayZ2k64cbaGmjRkI5gUdYhyjJ+MFH3JQElWRKsIfhSwyJc
	 Yz+HncQOlZXuKNV9+MXrVRIaMTYZyjznmy8/DRy0gEdoFG7uwzN8T51TGZ4p4h9MSKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=fQa0eja15vhLF1dR81uMAkBZdgojQ41rPu6DLnChidU=;
	b=So8DNZNl0mgY9OalDHNYM0t78RWhxvkBDGHsev50Sa0XUd2bGeaRcP8Il84MXTl9I1CJ
	 /ajF8ZdAzU6EnPWRHrboX0X8zvyow3o5gpM0e19sfMKTzQCzATPdXFCktLiypcgULHxdU
	 OR89EAXL+0b7zqM1DXrOBAucREnDSDyy78kHWRHcoZj87p8DKLLTcX1vkKHgTowVOjVoz
	 TldUwkR8xGYVKQBtNYHOCbhBP2MIzP272PgukpXv3FTPiYu/XPV28k8+eg0RORjXQAQSJ
	 T3C92qGxZrFBWXMc9ZDsxk0w/9L4ttWw+KIJf7tZtdD4LqwHGYNwOZfohYQWV4cl16Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZqScKzq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB7760A2601;
	Thu, 29 Oct 2026 02:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZqScKzq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DFC1F01828;
	Thu, 29 Oct 2026 02:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239394;
	bh=fQa0eja15vhLF1dR81uMAkBZdgojQ41rPu6DLnChidU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZqScKzqWByNxigq0hWDfqnnxX0RxqcjRIy7jYL5PGdNXJdyS2GGAsNB0L0/jxblz
	 z5zYF5p7wvVOOBaJRlQkf5quVF0m/tTBpNJzGzoiUAMZ1EKm/bWiPl5VmIniNCzOi4
	 dZLlRSTjIQfSCeCIr4D2eo+Y/AfxuREPZjzAceTNn38FMjexOFE5DKtRVh5kbnSxQh
	 RsWaQHkH9TjmjfNhmphc2GUw4GXhqLT8ez92+/q14A10Q4suAUW1VkXtkXBxkIgGfq
	 sSLKMkP2aHQed/TQLG1HAFXkPTVBcUeJPO+f5ICLnjc3aYCcL3HcuN4rjmNziyyr8Y
	 SqgEMlHM/7uXw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: sebaddel@cisco.com,
	Karan Tilak Kumar <kartilak@cisco.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com
Subject: Re: [PATCH] scsi: fnic: Update module authors
Date: Wed, 28 Oct 2026 22:02:50 -0400
Message-ID: <179323465397.491807.6385663707673208726.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261020210043.5279-1-kartilak@cisco.com>
References: <20261020210043.5279-1-kartilak@cisco.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 20 Oct 2026 14:00:43 -0700, Karan Tilak Kumar wrote:

> Update the FNIC module author list and bump the driver version
> to 1.9.0.2.

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: fnic: Update module authors
      https://git.kernel.org/mkp/scsi/c/c2c645243dba

-- 
Martin K. Petersen
