Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153E75336D;
	Mon, 12 Aug 2024 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723474152; cv=none; b=MbMdWva4BviiyOS3F3IqFdcZmqcVhrVSkk8vXldKBUevT76nP3GSOIrVMTqP7t8QPKQEAb/rVl1t56Qi7ZVnNgEi6NV723EAjJJGZlGp6JUKtn5LBMZrtUhZmY0QvvvJbbmqhH/MDSsZKyCD5G8oJFtGZWn6ezzXYzv/gi4WWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723474152; c=relaxed/simple;
	bh=3YHqQtytKnWfaRgX1e6PxdHqxsAwo6yex8Xz+1qPIJI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WLcnHOjwspa628glUSvyscflF3LpibVEjFaFbc+vkKCZ9puXPnYftcMOGq63nFLu/qjKggqURZziXBNgf8gsq3v6PBp6uTVxLj3jVCMAHdxn5pmmat+TcIoYs7HecZFp0MqFQVyXgUbL8y+qOo1TOZ1W5SumZspOnk1yxHwRuTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCmY3C/j; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCmY3C/j"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2f0dfdc9e16so52647841fa.2;
        Mon, 12 Aug 2024 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723474148; x=1724078948; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sT4ZxonCbYWzpgFog0M5IWFMz1arCxSNVkzEqPlqcnY=;
        b=CCmY3C/jh0tjTSuPTP8iah9sRPoyU8O6fkaoP6hCKoi87ZaHCDV7VPPxMHNvMMy+rf
         h4Sk49Ti51zbt5eJ1+lk8cXgXlIgIC5h+vRbv6X6CYM9l3q667sQGREAsJPAFYskYO2H
         afQWH54lAqK8HE1iKldY//iMBZbSztb+NS0hTWFQNSx9Kh0n43lREw1CnKAd5Hmcdl63
         J7h0no3Z0oqqDXuuAQ8yykpuwpVqahGQfz9CCMnrUlgRgvIuSl9WDFmAQwltbSXVTlVo
         vk3cwSpEYhbzHMXKHjC/uMLPexxGfo/tUw9BDSYPDIugY8YxXpaWVhrtcPdgmbWF14Ea
         ss8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723474148; x=1724078948;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sT4ZxonCbYWzpgFog0M5IWFMz1arCxSNVkzEqPlqcnY=;
        b=mg9oQebSOpaDSVKWThsa+FqYg58U0u7OhpqkXhFF/fNqc2N6hN8d88NEFMykk8W68G
         RfAxJ2jwvRKkwURq+ZdYmTfLaojOjoFbMA2GzlvC+7oYuRVLhESfA3x9TuYlSC0k2kWz
         uUmW5Ad9OCZrqSHA858GjdkwdbmdnIaC8nMPm8yVXi6Nuyp2nvYcigkJVU6tncGp1tev
         Z08KGUK3SeqiaESYBDD+kSSqd5HgTm+E8iYaLbJkD60dS0MIn0+U5tbOAf4OFijHzJwc
         dW3+QBdYIGgQjNE2eLriQMWPlo4ZXLBOegm6pVsHWrInrCRazQEYTViyx1LyQmR5fxs0
         714Q==
X-Forwarded-Encrypted: i=1; AJvYcCV7o0K1YFnnHFhgSSdNuAdSU2K0UD/PmxDFQM1Op6wt0+lxXaDVa6XvIotvAmUGl7Anml/vGWeZp3mp1QUPDXg3BbHOuzBlv5pqfuEPSrQSCKhnVsDcEUnenhPq53To2IcMjSeZ+uA+RQ==
X-Gm-Message-State: AOJu0Yy2mOQ+jNY01UuEvPSdnybJrfTrMm8XTE4cqAw/5F1qBR/QbPB7
	tQ/1HgRuS8oTA51PQZNmx9cj6z+jvcG1pXwBGdOMRecLXDhz5Tus
X-Google-Smtp-Source: AGHT+IG7Z+dew1+Lz89SyYi/nXsRanYmQRi5NC94ZQy1HZC6uyZdPTQqgPkW6UvMuolXWkKB3ezb+w==
X-Received: by 2002:a2e:a99f:0:b0:2ef:2eb6:e3ed with SMTP id 38308e7fff4ca-2f2b712cc81mr4564561fa.4.1723474147051;
        Mon, 12 Aug 2024 07:49:07 -0700 (PDT)
Received: from debian.local ([2a0a:ef40:885:ed01:895f:a056:3282:b682])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429c928908esm69670245e9.0.2024.08.12.07.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 07:49:06 -0700 (PDT)
Date: Mon, 12 Aug 2024 15:49:04 +0100
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: fengli@smartx.com, hch@lst.de, martin.petersen@oracle.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [REGRESSION] critical target error, bisected
Message-ID: <Zrog4DYXrirhJE7P@debian.local>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Machine is HP Aero 13 laptop. The following error appears in 6.11-rc3
when booted from USB drive:

[  195.647081] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[  195.647093] sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[  195.647096] sd 0:0:0:0: [sda] tag#0 Add. Sense: Invalid command operation code
[  195.647099] sd 0:0:0:0: [sda] tag#0 CDB: Write same(16) 93 08 00 00 00 00 04 dd 42 f8 00 00 2d 48 00 00
[  195.647101] critical target error, dev sda, sector 81609464 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0

This error appears on two different laptops with different USB drives.


Bisect result:

f874d7210d882cb1c58a8e3da66f61cdc63cd4b4 is the first bad commit
commit f874d7210d882cb1c58a8e3da66f61cdc63cd4b4
Author: Li Feng <fengli@smartx.com>
Date:   Thu Jul 18 16:07:22 2024 +0800

    scsi: sd: Keep the discard mode stable

    There is a scenario where a large number of discard commands are issued
    when the iscsi initiator connects to the target and then performs a session
    rescan operation. There is a time window, most of the commands are in UNMAP
    mode, and some discard commands become WRITE SAME with UNMAP.

    The discard mode has been negotiated during the SCSI probe. If the mode is
    temporarily changed from UNMAP to WRITE SAME with UNMAP, an I/O ERROR may
    occur because the target may not implement WRITE SAME with UNMAP. Keep the
    discard mode stable to fix this issue.

    Signed-off-by: Li Feng <fengli@smartx.com>
    Link: https://lore.kernel.org/r/20240718080751.313102-2-fengli@smartx.com
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

 drivers/scsi/sd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

#regzbot introduced: f874d7210d882cb1c58a8e3da66f61cdc63cd4b4
