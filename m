Received: from ste-pvt-msa2.bahnhof.se (ste-pvt-msa2.bahnhof.se [213.80.101.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41B73BE14A
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.80.101.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775242350; cv=none; b=CKf62dUi/NpR3gcoAzC3p0HX6RPS4uA9sOP+/jlE/eXyEGv7LdD4gCDwdtdE+e7TLXWMdTY5D8YSD1xyZz2aG08GCAOqVL6+1YUEc5RIOYKIpuyit0E5THrlAgyAj7+amRarDumVusHJxlPZNW6RZUKM9Pg0bJfutnKACdMdgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775242350; c=relaxed/simple;
	bh=mPImerMNP/V/hDzMHF4+rRjBc2sReGFodKUvFDXAVCc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lIySToOZw7SSCz9YgT6aPRWhmfhoRk8xCU0C99+3D/My2XYOIXnSn9OUZLcmzHlfUsy196q3zKs34myvyQdenF8eK419Xf8zdMI6M3YE9U+dNIfMDaAlzqfyj94IvCi+0KN/o7TFjjFIOSMl1dm0UJCNcnLansJPGjL0UadlV84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bahnhof.se; spf=pass smtp.mailfrom=bahnhof.se; dkim=pass (2048-bit key) header.d=bahnhof.se header.i=@bahnhof.se header.b=liNwHbKg; arc=none smtp.client-ip=213.80.101.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bahnhof.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bahnhof.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bahnhof.se header.i=@bahnhof.se header.b="liNwHbKg"
Received: from localhost (localhost [127.0.0.1])
	by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 76C103F387
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 20:52:16 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.1
X-Spam-Level:
Authentication-Results: ste-pvt-msa2.bahnhof.se (amavisd-new);
	dkim=pass (2048-bit key) header.d=bahnhof.se
Received: from ste-pvt-msa2.bahnhof.se ([127.0.0.1])
	by localhost (ste-pvt-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4ThvLa99sW3Y for <linux-scsi@vger.kernel.org>;
	Fri,  3 Apr 2026 20:52:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bahnhof.se;
	s=default; t=1775242335;
	bh=hR+4hnYf1hEslcVggSMkYSqgUSzZvFlhmqv+sXl9pm4=;
	h=Date:To:From:Subject:From;
	b=liNwHbKgmjvd4ZSVFAtZlWDJZbXG14gdF1auzhvxIiQtvcBWUJ5nSSIONiOfyyWvR
	 Mc9EGFngY9GFVXpMgWSKmtgQStZJslEXyAEy0pCsTSeEVI5m9Rrpx28NCpwM/LeH+D
	 kQHeJqRgp8Kj9gwXGAOZ/VJBzFs5XiKK/aXOZkCtBpkZay+fNxI7uXbSUTNoLZ9jLB
	 4qrrwsL8aTrlUFq0Tvj+DyyTeynx/LsL9T1ucLSc1go4BfK5TekYenGlZ1bCw6HbpU
	 Mva/4MtidY2mEb97Zb0Aa5jiPmJw020sxFZvX2JKTPsnWnLGfG/a8nO9zvy9AgCLAo
	 Zs8Pl9SEzxRZQ==
Received: 
	by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id 55FB63F314
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 20:52:15 +0200 (CEST)
Message-ID: <b8c4c8f8-2b7b-4e35-a750-cff8b50c295e@bahnhof.se>
Date: Fri, 3 Apr 2026 20:52:15 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-scsi@vger.kernel.org
From: Johan Gill <johan.gill@bahnhof.se>
Subject: How to handle StarTech adapter
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello, I was directed here from linux-usb, so here goes:

I got a USB-SATA adapter from StarTech 
(https://www.startech.com/en-se/hdd/usb312sat3cb). It is more stable 
than my previous adapter (which was some JMicron-based thing) and is 
running on full speed AFAICS.

lsusb says "Bus 002 Device 002: ID 14b0:0207 StarTech.com Ltd. 
SKC6002048G" with my Kingston KC600 connected.


However, there is one problem: I cannot run fstrim without custom udev 
rules, although the adapter is documented as supporting TRIM. With a 
custom udev rule to allow it I have run fstrim twice this far, and 
smartctl with -t short reports no errors.

The cause turned out to be that lbpme is not set, so the other VPD 
information is not considered.

[johan@Corner linux]$ sudo sg_readcap -16 /dev/sda
Read Capacity results:
    Protection: prot_en=0, p_type=0, p_i_exponent=0
    Logical block provisioning: lbpme=0, lbprz=0
    Last LBA=4000797359 (0xee7752af), Number of logical blocks=4000797360
    Logical block length=512 bytes
    Logical blocks per physical block exponent=3 [so physical block 
length=4096 bytes]
    Lowest aligned LBA=0
Hence:
    Device size: 2048408248320 bytes, 1953514.3 MiB, 2048.41 GB, 2.05 TB

[johan@Corner linux]$ sudo sg_vpd -p lbpv /dev/sda
Logical block provisioning VPD page (SBC)
   LBPU=1
   LBPWS=0
   LBPWS10=0
   LBPRZ=0x0
   ANC_SUP=0
   DP=0
   Minimum percentage: 0 [not reported]
   Provisioning type: not known or fully provisioned
   Threshold percentage: 0 [percentages not supported]

Would this be sufficient to have a quirk for this case? Let me know if 
you need anything else from me.


