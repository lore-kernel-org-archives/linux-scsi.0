Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184ECC48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 13:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04ED1610A2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 13:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhFINrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 09:47:02 -0400
Received: from mail.teo-en-ming-corp.com ([194.233.66.226]:53452 "EHLO
        mail.teo-en-ming-corp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhFINrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 09:47:02 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2021 09:47:01 EDT
Received: from mail.teo-en-ming-corp.com (mail.teo-en-ming-corp.com [127.0.0.1])
        by mail.teo-en-ming-corp.com (Postfix) with ESMTP id 4G0SqM0mMvzk1qV
        for <linux-scsi@vger.kernel.org>; Wed,  9 Jun 2021 21:38:23 +0800 (+08)
Authentication-Results: mail.teo-en-ming-corp.com (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=teo-en-ming-corp.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        teo-en-ming-corp.com; h=content-transfer-encoding:content-type
        :organization:message-id:user-agent:reply-to:subject:to:from
        :date:mime-version; s=dkim; t=1623245901; x=1625837902; bh=gtT/E
        PPndgGFqi40Ezol7vIKHfNm9ct8I54hIY1GoNA=; b=V9Xy3FaZ7bzNXRmYxKuzq
        3laP+JRqKmofRay2E+rZlkwlm+ER/apCaHYYSaV8Kfh9jEN4ele4yD6DjO7E/P9l
        KsiE8tbBeuVw4f44nLz/Zf6p4vH+sHysYuL1fQrmOqZ4WkpMfbsB1NcB52dbiP1/
        E/VS0oUa6oNDTLtJDcDHFCEAgVF8PmVG9CA/yZgBJF/AobNn+6IeP0AGR6UgDb8d
        RGd9uu4ElVFQcRSq9U8RQ2v4WO7XPWp/gRWtav+doQCO3+wX16mMcBmpwucs54sr
        gHYchzslKxM0xlJ99axXVW4vDitLm5gecssgCYgp7PFOIntsTiPT9jfsXv0eKdQK
        Q==
X-Virus-Scanned: Debian amavisd-new at vmi576090.contaboserver.net
Received: from mail.teo-en-ming-corp.com ([127.0.0.1])
        by mail.teo-en-ming-corp.com (mail.teo-en-ming-corp.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4fsz-EJBcYjC for <linux-scsi@vger.kernel.org>;
        Wed,  9 Jun 2021 21:38:21 +0800 (+08)
Received: from localhost (mail.teo-en-ming-corp.com [127.0.0.1])
        by mail.teo-en-ming-corp.com (Postfix) with ESMTPSA id 4G0SqK4Bdmzk1qb
        for <linux-scsi@vger.kernel.org>; Wed,  9 Jun 2021 21:38:21 +0800 (+08)
MIME-Version: 1.0
Date:   Wed, 09 Jun 2021 21:38:21 +0800
From:   Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
To:     linux-scsi@vger.kernel.org
Subject: [Verified] CentOS 7.9 2009 Linux supports ThinkSystem RAID 530-8i
 PCIe 12Gb Adapter
Reply-To: ceo@teo-en-ming-corp.com
User-Agent: Roundcube Webmail
Message-ID: <0e60cab9c85571253cfd85dc782eee65@teo-en-ming-corp.com>
X-Sender: ceo@teo-en-ming-corp.com
Organization: Teo En Ming Corporation
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Subject: [Verified] CentOS 7.9 2009 Linux supports ThinkSystem RAID 
530-8i PCIe 12Gb Adapter

Good day from Singapore,

I had a chance to setup CentOS 7.9 2009 Linux on Lenovo ThinkSystem 
SR550 (2U) server for a customer on 8 Jun 2021 Tuesday.

The hardware specifications of the server are as follows:

Lenovo ThinkSystem SR550 (2U) Server
=====================================

1x Intel Xeon Silver 4210R 10 Cores 100W 2.4 GHz Processor
1x ThinkSystem 16 GB TruDDR4 2933 MHz (2Rx8 1.2V) RDIMM
2x ThinkSystem 32 GB TruDDR4 2933 MHz (2Rx4 1.2V) RDIMM
1x ThinkSystem 8 GB TruDDR4 2933 MHz (1Rx8 1.2V) RDIMM
1x ThinkSystem RAID 530-8i PCIe 12Gb Adapter (RAID 0,1,5,10 - Zero 
Cache)
1x ThinkSystem 2U x16/x8 PCIe FH Riser 1
2x ThinkSystem 750W (230/115V) Platinum Hot-Swap Power Supply
1x 2.8 m, 13A/100-250V, C13 to C14 Jumper Cord
1x 2.8 m, 13A/100-250V, C13 to C14 Line Cord
1x ThinkSystem Toolless Slide Rail
2x Integrated 1 GbE RJ-45 ports
8x 2.5" HS Open HDD bays
Warranty: 3 Y P L, Onsite, 2Hr, 24x7
ThinkSystem XClarity Controller Standard to Advanced Upgrade
ThinkSystem XClarity Controller Advanced to Enterprise Upgrade
4x ThinkSystem 2.5" 2.4TB 10K SAS 12Gb Hot Swap 512e HDD (RAID 5)
2x ThinkSystem 2.5" 5300 960GB Entry SATA 6Gb Hot Swap SSD (RAID 1)

Using XClarity Controller, I was able to create RAID 1 array using 2x 
ThinkSystem 2.5" 5300 960GB Entry SATA 6Gb Hot Swap SSD (effective 893 
GB) and RAID 5 array using 4x ThinkSystem 2.5" 2.4TB 10K SAS 12Gb Hot 
Swap 512e HDD (effective 6.5 TB).

CentOS 7.9 2009 Linux was installed on RAID 1 /dev/sda and the 6.5 TB 
RAID 5 array was detected as /dev/sdb.

Using the Linux commands "fdisk /dev/sdb" and "nano /etc/fstab" I was 
able to mount /dev/sdb1 automatically.

Inside "fdisk /dev/sdb", you have to type "g" to choose GUID Partition 
Table (GPT) to support more than 2.2 TB of storage.

In /etc/fstab, you just need to append the following line:

/dev/sdb1    /data    ext4     defaults    0   0

You can create an ext4 filesystem using the Linux command:

# mkfs.ext4 /dev/sdb1

In conclusion, I have verified and confirmed that CentOS 7.9 2009 Linux 
supports ThinkSystem RAID 530-8i PCIe 12Gb Adapter.

Mr. Turritopsis Dohrnii Teo En Ming, 43 years old as of 9 Jun 2021, is a 
TARGETED INDIVIDUAL living in Singapore. He is an IT Consultant with a 
System Integrator (SI)/computer firm in Singapore. He is an IT 
enthusiast.





-- 
-----BEGIN EMAIL SIGNATURE-----

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of
U.S. Embassy Workers

Link:
https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwave.html

********************************************************************************************

Singaporean Targeted Individual Mr. Turritopsis Dohrnii Teo En Ming's
Academic Qualifications as at 14 Feb 2019 and refugee seeking attempts
at the United Nations Refugee Agency Bangkok (21 Mar 2017), in Taiwan
(5 Aug 2019) and Australia (25 Dec 2019 to 9 Jan 2020):

[1] https://tdtemcerts.wordpress.com/

[2] https://tdtemcerts.blogspot.sg/

[3] https://www.scribd.com/user/270125049/Teo-En-Ming

-----END EMAIL SIGNATURE-----
