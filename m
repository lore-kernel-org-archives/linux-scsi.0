Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239396;
	b=lnNandQVIjGS90sX5dGjdQeBYPlJt4AW1VlzkoISeeySiTz6/vPLr+PHIf8oabqwD1em
	 rfWROrRIh/d0aogzn/rb2yoZX6G65tOSECvBVbDxac4oKofgF18AzU2l9KaO704C/0Ho3
	 VuXOvI7ci3cBXxm8Cy35yxqO6vGy8W7uH9fUN27jSCKhgp04UWK/oYzPRJhLQ+Ml2v1uW
	 reQtnU5bpUeDBCWr+iFhsxQjrFUoWIFY7X0+amumg2lZz3RaEfVFQD8aUBgKTIBDvPDTu
	 BRu8TGgBxcJpIuPQg7UOGx3LnK7NKK3KAjWhB69Ju3pvQe4cxxOAcQNKBtDCUx3YV/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=on8gqtG1j+0rAzzN0Z5eLemNuzaoW8ILAYCDnqO8v6M=;
	b=HigFuuLuLCDoUbD08BaOM8HdGdjBlcT8mCtNT11mSuQFfksOjFYds32iYWfykiodeo/S
	 aTPQy5WN4J6LLNEcsqjNO6chdE+nsb38FKfh1yNNv7OSGjdmaTVFqjjnrwfKVlnxhj9fd
	 HxSd3Ibs7D9kY80cH65M54LE4fow0lWGXkjVRwfuIJeo6sjpXjwrfLXZ4Kalzlzpsno7W
	 3Bx4rAu6N1lBheyZkbK1SdRfkzygx16WPZZSTIprmMGUFnSi9tp47UCBCWM2bVRDa/LdN
	 TnVhjXNhL+Vs+SCD8PcyTEwKrtTt5BNuYrspcANvvElCRaxW7Zlpnyyaon+GamCjDMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EiCnB352;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA82606A324;
	Thu, 29 Oct 2026 02:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EiCnB352
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9CA1F031E3;
	Thu, 29 Oct 2026 02:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239395;
	bh=on8gqtG1j+0rAzzN0Z5eLemNuzaoW8ILAYCDnqO8v6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiCnB352y+EAM+oJSlL35a48IW4IUCUM5o1moLoeS6C5hHDzerAxhKf9ADJmdadzW
	 FwVQJtf3HhOQHQjPxLdN+vILnblipDu9dJjlWg/n/gJ9mGTsFIrtJY4YgDSBP0vhkA
	 rHc9PCDD70Hfs+Ys+9t1FXRptOem+IreIQoZuEwQeTpT3yaCSSnlWdvK+1YdRY9Utx
	 E2R6AJE/5c/jjcOx4cPAAb+QXXkPbCFffCkIeywi0UMue5ivSTytXFw8P/zwZ+WQw0
	 hvRmALTUBsb7Gay0glLa+MYK7oj9Syhq3v3B9MuiTVoW1lIBKk+HWILrZb5j58YDVf
	 egxPBIxAFIH3g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Laurence Oberman <loberman@redhat.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Laurence Oberman and John Meneghini as SCSI tape driver maintainers
Date: Wed, 28 Oct 2026 22:02:51 -0400
Message-ID: <179323465387.491807.6460162055802465058.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261020125059.1797559-1-loberman@redhat.com>
References: <20261020125059.1797559-1-loberman@redhat.com>
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

On Tue, 20 Oct 2026 08:50:59 -0400, Laurence Oberman wrote:

> The SCSI tape driver (st) is currently marked as orphaned. Add
> Laurence Oberman and John Meneghini as co-maintainers and change the
> status to Maintained.
> 
> Also add a link to the tape_tests repository, which contains the test
> suite used to validate the st driver.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] MAINTAINERS: add Laurence Oberman and John Meneghini as SCSI tape driver maintainers
      https://git.kernel.org/mkp/scsi/c/2ff2d1b892dc

-- 
Martin K. Petersen
