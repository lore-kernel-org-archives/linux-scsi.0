Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703FD1E2858;
	Mon, 30 Jun 2025 08:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751272031; cv=none; b=E/3y1RXk7r+1mmzJt6YvCUmE6L6qVH/3sJy8Hk78yO4BY74N0Wsy2RT8p7n52j32YWnZDMv+H1lRodNSGBzm0u5N6tqyt+HxkrBH/7x67Cn2/KPFZT377ASpiJ0YBo8p6ts0jyDrkg0Y0J4B48lG4YAkFvxAPWjGCmIDZ19pptY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751272031; c=relaxed/simple;
	bh=lLupGE83slk6Rc7n8lXUVq8/KuU2FXMNUgqrMet+k9Y=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=gZ+wire7R084mGRvkwEBfJR2W3kUp0x+kObBJgP2vL/xurXtLW0RDFhiDj3BTriLWRzW0RfVPba/46fZZ3tWoImNnceSUZplNeoHNVxmEOdw3TKLsvFWSZrqUkWmqEce4GiwnpbhF86nCH54M5b+f/llZQMHnSd9jp/YLmpuyVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=s6P5h7yn; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="s6P5h7yn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1751271715; bh=XZ0aFEqYQnkKoHskDEAXjLCNAGRjf4o/lr5Ys3ymZFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6P5h7yn9w47iE+mDDC6mtgQGqZftLAdzLV7/kSKDlFmXIQvraow2XGLqY/IQJvaf
	 y3rJePUFEVcXC2M+QhzS7cFddu5ntRCXZ0dXifzt9UkP5kwtEVP7tqKvYRxjLdlnmL
	 IagrSF9uomHNt9cvBmxCBFv7BNnIshNtHs5f8828=
Received: from VM-222-126-tencentos.localdomain ([14.22.11.161])
	by newxmesmtplogicsvrszc13-1.qq.com (NewEsmtp) with SMTP
	id 5762EAB6; Mon, 30 Jun 2025 16:21:54 +0800
X-QQ-mid: xmsmtpt1751271714t64qi34cy
Message-ID: <tencent_12DB60FFE724D17784666194FAB42BDC9A07@qq.com>
X-QQ-XMAILINFO: NT7dO8ok7FP2v7xRnUhcmt4Rdgr/FlUPPDgif8LsnLpTyNsvGaF723Z0bqBqz0
	 PshyKa3HtCjgKU2dVS/syvcz4z+xP9JipP1BjGfhUOJYwq6z5Atw59v9HrqtLdw2JeB+MRq7OYoL
	 oAllUh54t7Z0pSKUybVcV2qIQUmA3uCMr916aFDOaJUX5PlslvMpNZz1ltwBlsdeMqF0TJmT8bHi
	 /+oi9Z2JnQVY2rumIrgIQeyVLTrhY6MejW+FXB/sKS3eChe8t0Ss9PwU9voiH5BVPXXYLaHUMYKu
	 MdpL8rLZdCBb01GAf2l/M+FKVNHEHlVZ0ZOL2kE2aCTyTP3e5uQwhSl/aIkiIpLjn0bfC11zQUG0
	 592PPym8ooPEFEuueECg2wOap0ySHrZ9WlCSJKQJRYUKR5EabqAoUgiY5kZ9vx20v3AFzFyyrFb+
	 VShQTTA3cAIkzAZ1WLrC3ACgJtxAjLD53ebFMED/pazYlX/XwSXo816Wc2AqPVGBJQ1tmmMphI0j
	 rTV95XKG3HVpMd8uI4rq1SXFChaarn0bIUIJF0MpxwDouLWVTUFo1Ycj55HacSl90BLPyU+vSMvS
	 cDF5CT0NlIiB9rtvSgCZBfI82TVQw8D2Q0rEMHRIHh/4cWZpdDITwEREkeMaaXQbtKeNW6kOROE3
	 GX7XiMc6RgoGnBdCRmjb/ApuaKh/7EcUTfGZvaekpI8Gh7FaTlB3/lRIIOZc85rFmEySBomAlGqq
	 SuGZVOaAOdkoY6WSqGlqzUezu5fjd8zV910J3eoOOw8lwc97adilROCNlxN5eQ3k7sQ6+odyV7n2
	 7kMZw3xjw2xmMmStCuw6ploJ1mp41B0vIT0oVQOfxtz38O64M97XguszWa+j0eU/VpZNvxOiDAbV
	 MobMSBmEc6adHwZRDO8CUrs9NjNVVrZ4Th/n1N7QDFoxyZvSSVyimdMiNamjFl6FJ94LC49ltNMf
	 dnlv1xqnso5GlQAeNrHT1IGm1BH797axccGEHbZduCOJdE2IMJvxwVX0CgZbg66/Wiyhc+Gyea29
	 miBy+t7TJ9ez6STSQsfyFoJ76zYaLMpzGuMIW77m19edtrqudfLN1U7szJbh/OaKFHdIODWw==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: jackysliu <1972843537@qq.com>
To: 1972843537@qq.com
Cc: James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: RE:[PATCH] scsi: fix out of bounds error in /drivers/scsi
Date: Mon, 30 Jun 2025 16:21:49 +0800
X-OQ-MSGID: <20250630082149.3798936-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <tencent_D9A0F9052526AD09F7FF76DD5F2529FDDD05@qq.com>
References: <tencent_D9A0F9052526AD09F7FF76DD5F2529FDDD05@qq.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 6/18/25 08:26 AM , Bart Van Assche wrote:
>> Can I know what kind of impact this vulnerability will have?
>
>The worst possible impact I see is that the Linux kernel would decide 
>that RSCS is supported although the device doesn't support it. This
>could cause sd_read_io_hints() to print incorrect information. The
>following message could be printed when it should not be printed:
>"Unexpected: RSCS has been set and the permanent stream count is %u\n"
>
>> And is it possible to get a cve number?
>
>You are asking the wrong person. I don't know how to get a CVE number.
>
>Bart.

Thank you Bart,for the patient review. I've submitted a new patch which 
mentioned way of detection and influenced stable tags.
Best regards.

Jackysliu

