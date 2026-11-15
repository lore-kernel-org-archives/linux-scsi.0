Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794735478;
	b=SPggSTd2PzgMkGXgXcqqifOZA2WxvBrsGyRD6I2ddFKF7Fzznn8hcoLbjr0hPn77dsMW
	 QAQv1o25F36qAzIbepyFBJ/ptr7vAUvvANDWIeqEZnl84t0GXSpTMg1IZYiG7z7y5wDyw
	 xVs3U+rqhnchPfnx5tFD2oOAy5yeFCiY5DJIPe/X0XtnO21C+yME+dQ7FBtbXMDLBEUpr
	 on3J2UiDLGKK1zXJrRX/ioWkTN0jTGuVo6egr77HGSaBLMp2d0K6IVebWTWuIK18nk5LK
	 drhWnhfauUjJ5L0NB6kLL8aE+6F9vTtpLjqXyYrcPROapdhi+DfLUw5osDrYnNe941g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794735478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LtkuQzOyrT1mRcVz8hwvU7jLW23P4CFjtItE8oCiOyE=;
	b=T1NbNNi5Ides5EfzZ2CFqdykVjoYKbzBtT6uhYQ/DNmqghWqvFh7cqnFhdIXSkWv3N1I
	 2MPUX1eqH+iKrRAs/LRsS0IjQ1uS4Xdpg5BdAa6QHvgvHcmnGhXRQVE0fk2KGMK15Nx/6
	 nhavjUgBW4bVS3tSgkcCOFwFx/uS+jDZcW6JN63/mwo/nW2qeqNoJ3owlFsJfK/lzF6fh
	 V8/nKaPsDm62RvZOFG+qGBmtm9y4Ul28swANZw+ZXSUh/OUNWvc/0l3CuSgwDR8TgGjEb
	 fXOeB1QpJrCUr5StQ22BiUyDvvLLpt+4+fcCBhdep/boBFQ2XR8yfzdFGV3Z52O1blg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uiXFqYlf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8AD606A31F
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 09:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B8AD606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uiXFqYlf
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0a519049aso2955957a91.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 01:37:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794735477; cv=none;
        d=google.com; s=arc-20260327;
        b=PH1zN41aGF5qQfJn/zxzRmwRcEBygl+UWneC8TPxAlX/h64p/pXGFhA2KguhV890XP
         l558+trCkv8I91yLqtxhsG6KkAILUAbGlg6njunWRgTG0kZIzH2ub/xphfXun7yZSrNn
         DcvA+HwE9qnfMnUVb+Qg/HUpuvY8K38MGLyJWlqHpt3ICTVXGlyKpef/Q/J9Wo3bC6/r
         FmekzI4f77ggCehERGDgO97dZ6mnO6m0+ju2/TOWgMrUz0OBWvCKO9SJ6mkx3Eo49b1K
         5kh1F1aF/Mg5x88cG48xQ7MWtJHVIemgyAm9OjI9XmKIGtc7pbN0xVHrJIV7Z33sFkv/
         rmKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=LtkuQzOyrT1mRcVz8hwvU7jLW23P4CFjtItE8oCiOyE=;
        fh=7I+XJWPHCRSuhD4z/r3jXa4YmPs94wkMoTzlRZIiWSc=;
        b=qD6yzbohsaI3Jj9XR9rLNq1FvHCJwJxxQ08Mv8YYsrdImq/Cx5ECsBlsAF93vKS9Gm
         eOegh93G1159AtdwiWC2J6PsWodcWIVJqzv/HXZJZIEKGaOISOF0N8PU4SmZD9hC9W+f
         yd3gZHsvrszKEoHAhgHbLJREnSookZ+N/si5zv5xxBO6RzKwNwuYryu32sMhzZwcqaWR
         fKvxEcvyBNQgegCUa6Q9WPf7crAfWcrooBspHu0Whet8Otjv84URhTfOYAOTafSsDjgs
         zELJ+Gg9gttuBk37k4LRmjMqN1WZJzPqrcqpmlriL7ATH7dG/4jtNsaHkoXfLOtHsaqf
         0ubA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794735477; x=1795340277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LtkuQzOyrT1mRcVz8hwvU7jLW23P4CFjtItE8oCiOyE=;
        b=uiXFqYlfT5VSs9whyeU/yo9LIqWaYe85jm0o92S42Apqy+qklKNyHJh1GuHb7nyEfj
         CAaQNTOzffk0/VcSFkCMza7U76QXEMM/hI0SVe7M1oUvXNCBfJf2lH+ea5r3B67WL6n6
         TVVgK0OKjL9AFtF++1wUJIoUifUSkwM5H0ApBVfb24JZrnToJO+44xFRfCxWFYon9wBQ
         KbV6SZyKkqTjkNp+ZadqlNzIb1sSCgx2DLfd57v8ZULkN7ia2035WcY7XUdQ5Jq6X3wJ
         8yMTw6kwpFfhza/Cq94Kkn1yiG1ni3EC43J0Lh6Qiuh0n8+L8K5pKAK32Zbjr+9ojbgP
         WqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794735477; x=1795340277;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LtkuQzOyrT1mRcVz8hwvU7jLW23P4CFjtItE8oCiOyE=;
        b=aaldYLou5KhqEhqkbH5vT97CiKTQF+v/+So2VRAWc6o7Ar3LN7D85IEjH50kde+oDe
         3+WX9LwyKYJujKIAlt177qFEyyHscxYzG/fSVTc5+eDJnBFWul8UcVOpJMt4VDJI/lTT
         N4pl+8VHUnz1AWAvQuDUXtbTyNnOzRKWBDiu1kdGN/eiGJYDSJZMeQjH8RFlSAJ+RiOB
         J0GjLa+L8Vn7EiyoUx//ksgxagdx25FIZW2orXwc/yWG/gCLDAHfsxMq0r5OoYKGK66U
         HVcZeanJm9+gSfe/eZ9CconvCwzwokTRW9kYNNSyLyIa/bm0A1vgc2hJcltqcGPrTOgZ
         YBOw==
X-Gm-Message-State: APuU4Z8XMda/jmBEh0nM3xlazKWpy/6SN2F/sa4hg0rnc6Tc4nuDQiND
	ObO6FIqnnQkpaJtBshmgqhP+WZKKLvhIaQA6M4oY0LpIBLbFo6uNJJK8eG9m++722CqPVtZxEYq
	c5FiQZ4IzuAQeTEXDasp0pYg6mE5JvkVZrsfx
X-Gm-Gg: AYBFou3jRCq8zPadDb7KWQJkGWlxnkOx+84TzGFgu2lv2aL/48YJOEqkycgXlDRPaNV
	cQHZX0Lui1yjK7EZS6R4SiiohzrmTmsSuI3zQadGaX4vp0gZVqWUX2OC0O6R+6/YeMbBNM3qKRj
	ET7d+RDyXvDbQjUm7iHCoqrxWSBC39bN+V6T9A65mzkIqc8ElXausWrKN90bQx8g94lDtb8ye0a
	YEsFNAHKcmrqtslPJw8WD7wmT89tkG0bVlMklyoWyeUUe3CEHObJtpjegwd8C2PwOPSym2pu3jE
	4UBHxplsF+bdBtXskfZ3vPox0K7Ea/PBSDvyXZ9C5/VlCQ9T0eAkp2fHcsTnhEletjoshrQsWsm
	vDu8oFM1LpR7TNh7TUfLNahVDtLrCPByTssLhoThBJZn3I2OO7A1N7v8=
X-Received: by 2002:a17:90b:3d44:b0:3ad:6090:a190 with SMTP id
 98e67ed59e1d1-3b1b0cac9bcmr7494391a91.41.1794735477265; Sun, 15 Nov 2026
 01:37:57 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: V S <vtsty.dev@gmail.com>
Date: Sun, 15 Nov 2026 11:37:45 +0200
X-Gm-Features: AclHuK-9BVAfXL_Gtksxc5pdYM9hOA8j0s5zBcEmdc00Rq8UBT5KUq5fwKVMfkI
Message-ID: <CA+MPai_cpz7TJQyDZg4spj-M8GHU0s7ZuP425tq3LNVk_d_pRA@mail.gmail.com>
Subject: ADATA Superior SH93 USB HDD regression since Linux 6.x
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello SCSI maintainers

I am experiencing a regression with an old ADATA Superior SH93
external USB HDD (500 GB, USB ID 125f:a93a).

The drive worked correctly with Linux 5.x kernels, but starting with
Linux 6.x it is detected as a USB mass-storage device and a SCSI disk,
yet read operations fail. As a result, the partition cannot be
accessed.

The device information is:

Manufacturer: A-DATA

Product: Portable HDD SH93

USB ID: 125f:a93a

Firmware/device revision: 1.50

Serial number: SH0210224160

Capacity: 500 GB (976773168 =C3=97 512-byte sectors)



The device is successfully detected:



usb 3-1: new high-speed USB device number 2 using xhci_hcd

usb 3-1: New USB device found, idVendor=3D125f, idProduct=3Da93a, bcdDevice=
=3D 1.50

usb 3-1: New USB device strings: Mfr=3D1, Product=3D3, SerialNumber=3D2

usb 3-1: Product: Portable HDD SH93

usb 3-1: Manufacturer: A-DATA

usb 3-1: SerialNumber: SH0210224160

usb-storage 3-1:1.0: USB Mass Storage device detected

scsi host1: usb-storage 3-1:1.0

scsi 1:0:0:0: Direct-Access A-DATA SH93 PQ: 0 ANSI: 0

sd 1:0:0:0: Attached scsi generic sg1 type 0

sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/466 GiB)

sd 1:0:0:0: [sdb] Write Protect is off

sd 1:0:0:0: [sdb] Mode Sense: 03 00 00 00

sd 1:0:0:0: [sdb] No Caching mode page found

sd 1:0:0:0: [sdb] Assuming drive cache: write through

sdb: sdb1

sd 1:0:0:0: [sdb] Attached SCSI disk




However, when the kernel attempts to read the partition, the following
errors occur:



sd 1:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_OK cmd_age=3D11s

sd 1:0:0:0: [sdb] tag#0 Sense Key : Illegal Request [current]

sd 1:0:0:0: [sdb] tag#0 Add. Sense: Invalid command operation code

sd 1:0:0:0: [sdb] tag#0 CDB: Read(6) 08 00 00 3f 08 00

critical target error, dev sdb, sector 63 op 0x0:(READ) flags 0x80700
phys_seg 1 prio class 2

sd 1:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_OK cmd_age=3D0s

sd 1:0:0:0: [sdb] tag#0 Sense Key : Illegal Request [current]

sd 1:0:0:0: [sdb] tag#0 Add. Sense: Invalid command operation code

sd 1:0:0:0: [sdb] tag#0 CDB: Read(6) 08 00 00 3f 08 00

critical target error, dev sdb, sector 63 op 0x0:(READ) flags 0x0
phys_seg 4 prio class 2

Buffer I/O error on dev sdb1, logical block 0, async page read

Buffer I/O error on dev sdb1, logical block 1, async page read

Buffer I/O error on dev sdb1, logical block 2, async page read

Buffer I/O error on dev sdb1, logical block 3, async page read





The important part appears to be:



Sense Key : Illegal Request

Add. Sense: Invalid command operation code

CDB: Read(6) 08 00 00 3f 08 00



With a 5.x kernel, the same physical drive is detected normally:



usb 1-2: new high-speed USB device number 5 using xhci_hcd

usb 1-2: New USB device found, idVendor=3D125f, idProduct=3Da93a, bcdDevice=
=3D 1.50

usb-storage 1-2:1.0: USB Mass Storage device detected

scsi host2: usb-storage 1-2:1.0

scsi 2:0:0:0: Direct-Access A-DATA SH93 PQ: 0 ANSI: 0

sd 2:0:0:0: Attached scsi generic sg2 type 0

sd 2:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/466 GiB)

sd 2:0:0:0: [sdc] Write Protect is off

sd 2:0:0:0: [sdc] Mode Sense: 03 00 00 00

sd 2:0:0:0: [sdc] No Caching mode page found

sd 2:0:0:0: [sdc] Assuming drive cache: write through

sdc: sdc1

sd 2:0:0:0: [sdc] Attached SCSI disk



Could you please advise whether this device is known to require a
USB-storage quirk, or whether there has been a relevant change in the
SCSI/USB-storage code that could explain this behavior?


Best regards
