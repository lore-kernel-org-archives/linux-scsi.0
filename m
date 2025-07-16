Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B54727991E;
	Wed, 16 Jul 2025 03:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752635195; cv=none; b=ZA6nk64LodUqTAbhcrbKqk1IJlCn8paAY1do+031YdiXNG/eZ5UIG+wiaq5kbFyMT+9ery1O9pScXG3hnw3yDjGRqYqa9uFRXFRU/YP3dEmryvuaGZymMxpga64LvMTX6c2ZhHNFK5B7jc46KypPdxibQl2/qYDPz1+DUSqvyJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752635195; c=relaxed/simple;
	bh=6VN9FKcTdtAorxviZrZKH9YBRb4tZy7sSEHppzE3GAQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=KuSsb5N9R8nYSfVk12IWDbKbniAQ//uQe+6E5zeWYaxegczpppyPrHme5kNFpDpqiMIHZyjx0cwgpO/EaM3/CVbYnuK7GOVtAgJUaS0LzOXFEWYi/CFSwUtGF9JJZR0/DKKsBN7z7Aj5/ZVYAqNEEDrXudlvsWvf+LMT9d63sP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=SuLSzZJd; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="SuLSzZJd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1752634883; bh=YUlCVgMJNmDjwrdJ6bJdu2yxm+8ftSfwyAUkzwsQpUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuLSzZJdHxU6KeYuhj+PNRVCx/cBprtyPO/vex5XQCyhY7qcBltt/Dmg7LTe5lMcF
	 fnyrs1jvxMARltzqoqg1X/UHSgPi9Pvs8Iszot8L1QEgoiXpl14Z2+3F543hfzlvOy
	 jlFrqlxzXM8Mtw/x6SXJtMI2Y4SscDEsyfo7k3nM=
Received: from VM-222-126-tencentos.localdomain ([14.116.239.34])
	by newxmesmtplogicsvrsza28-0.qq.com (NewEsmtp) with SMTP
	id 55B267D; Wed, 16 Jul 2025 11:01:21 +0800
X-QQ-mid: xmsmtpt1752634881tvzihwlbp
Message-ID: <tencent_69EF08CD5A280B69E9B808B7F1FE0849B608@qq.com>
X-QQ-XMAILINFO: Mkw1Oys1xyjCqHS8GC7e0ScOgMtTBIxcDhaN+oEf1F4AmDdo7uzWLeM7YQuU7V
	 mXyrXvPpnC+aZPkWYPhe0ImL/FdCYiDKoOeXgb3CJesW2XxyF8W6E/0U6F1VQ7F6thpayQxzzxCH
	 0v8+vaWWkI1kzeQTj73BS2lK/LBHUrUzBO3fqyxf51+08uKwESE3qJIgD/OI7VGgNrEMFqIdFLar
	 MyvUWCNhV/jMrgy6ldtbgBoAht4MGC0ou5JUdz6oH1AWFKSAnIZwQPUQfo35RmsMn9S0NO9/wUUO
	 ctJ5hVyeDpKjUS3EbXBxmRvNPHCph6hVPm6LVlVLRCWBXs/LZzAbcuFqiP+dudpgNEp69DdqbURc
	 2zqz/HLXML24iVvTeITbPoPC2/gompl0xtYgoYbjsy83vaM/sNgJvFsWJTTiIFWEsOVpCF+QbjZs
	 0H9WE7LrilOcmrTLuPwWhFqFlMFpa/KNQ1Zv0D9JjtGtuk0J1EBZgS1DEjeZpW8kNKsMGr4MZY7b
	 rpVdWQmEN6IEDraB8bfgyABbpOoka9snttftEWO6w3icTG5Z2EiItMGUpRO3wdmaINDG4yCRJMMB
	 Blx5P9SXXaQ4G8USLpGe1sb1a7THPHY2ZTcXPgKFaenq9R8ak7lI+D3YgEXnDHvWmouLaDxFKI7U
	 Tp4P1v2sm/S1PghQq6rV0xlM3SVOetMywpfpxlCeMGtwgQPxiB2MEwldLEaZcN8Rk391jRUShNuY
	 ryF/KRtCL6xa8wyJyMeVBZSKlESlRtl6Nh3pLRqYViE9t6WmUDblvQ08brWkE8KN+Nm3wRGvGhGj
	 ISL7AO2hwXPY+RVpC91fBu68WjlTcShNV9lzLWxj9AEI6kIYf9EMrWom0MzoFtY9F3WqQsX1xA0A
	 A814iLcFuZ3v719jfQueWKBTc1riGyh1zwUyrm9Mmgj423KDre/XcfS0xfrXzFR6/ZYIhJ+hqHSf
	 1ha7ap9RCvXtA0I120REjnGG1eTLX26RHBTKDxY52BaqN08BImwBGwqHwYbkT9ZgrwTUGoqXIkmF
	 0UApSKbivyINxM8b0r
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: jackysliu <1972843537@qq.com>
To: krzk@kernel.org
Cc: 1972843537@qq.com,
	James.Bottomley@HansenPartnership.com,
	anil.gurumurthy@qlogic.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	sudarsana.kalluru@qlogic.com
Subject: Re: [PATCH] scsi:bfa: Double-free vulnerability fix 
Date: Wed, 16 Jul 2025 11:01:16 +0800
X-OQ-MSGID: <20250716030116.3958471-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <f75182a8-90f9-466e-a96b-d454c770f0a5@kernel.org>
References: <f75182a8-90f9-466e-a96b-d454c770f0a5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jul 15 2025 12:45:00 +0200 Krzysztof Kozlowski wrote:
>You should disclose that you used some AI tool for that... and that
>other report(s) was really fake finding.  People should know you
>generated it with AI, so they could make informed decision whether to
>even allocate time here.

Although this problem was detected with the help of ai and static methods,
I checked the trigger path by myself and verified this problem. 
I'll describe the ways of detection if I find other issues in the future.
Anyway, thanks for your review.

Siyang Liu

