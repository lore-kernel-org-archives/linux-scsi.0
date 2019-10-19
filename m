Return-Path: <SRS0=fvsq=YM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0747DCA9EAB
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 13:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D244F21925
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Oct 2019 13:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfJSNGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Oct 2019 09:06:54 -0400
Received: from mout.perfora.net ([74.208.4.197]:57719 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfJSNGy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Oct 2019 09:06:54 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Oct 2019 09:06:53 EDT
Received: from marcel-pc.lan ([81.221.67.182]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MPGuf-1igW2N1Yr7-00PgmW;
 Sat, 19 Oct 2019 15:01:50 +0200
Message-ID: <f59161ee331a715f0a4996058ece6ce9363708ae.camel@ziswiler.com>
Subject: Linux Firmware Update of a HPE Ultrium 5 Tape Drive
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-scsi@vger.kernel.org
Cc:     Doug Gilbert <dgilbert@interlog.com>
Date:   Sat, 19 Oct 2019 15:01:48 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:0g+k3StFg4GpsUk8ddYyfj5c+h3tKZ5kT/nrc6n0Q+wORbZ48U+
 9XmJHpUmf0qwB2q+PeFp9+63K8SjhBsAS+4lADpAnAcfU0jmyWekPu35ynpa4wjISl7X6un
 J1pdD6XwRjOZh0xCgSGZCpSE7sltBT9IFC1SfKsRewls46fkDnCy0V5brzMekbEQt5lBfIl
 IlIuT4WoAdX6FpkNP1htg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SmcfyW4gSHo=:yfMcI4j+BziMqKLsHB3iOq
 QuTzkNI2RN4xP3MsxyL/S4dgSDZy3LHinhdgGMjwR5ZZPVyo62GVc9qz21bA/z8w33LQl4m4k
 7J9m8JIB0btHkLzujCKna0ACnfgYm20EhyAmuTevAKbO4fj4vs0IwWalKq16wPE9tdihxoRVc
 Zl/dpsewHIiPVKkIWhDP2tp+v3nVpd1bsQzE4Yv5H1hgJglwdTawkrXq4o5c1UM2Tf7Q7a9td
 o6xO2ze3e6ksCzmGh58eRkmIjN5QYPibgkyKzbsDhU7df3CotQgcF/rs7zQkC7KZYO+dPTVqU
 c7ZYhdvAjjr/MqmoXq6dTTy7wi63MyzWpdzY3iXMHljQODXEDWklfoXVt+VYbyDIoMRqqzbw8
 PRD3saGTitU0aVHTLfBk7CTBg+c/Lhzwyfm0EQEO+dwqhyPRSAYWi6zKB5vTC0zNKlKlfMzNT
 /DBY7MiK8utAB0ohiaHea2tzvh0ocMT85v0lo99btLWe7LccBZK1No7h32WjSDC0Xtje0Ewkm
 9tv3ObVD0YP7IYCs/zLDTiEWhuaiZkHZTpzv2XNZn+GBHfN2u8m9IbJYT/1zGzxKPd/9coGyp
 V84507hJ6IP0d5u1g7T0ZINMtfsvJAH+XoS/rWzHQaw4E/w/Ee/8aw3CpzBtmfUg9Fte7IkgD
 Lxfg9uGO4nlXui5Cr3O2UJKlT0XLe7AapuRlP08l28piqkrfUY1Aj1qdp8ikHb9e/G19f2thZ
 my5S0jstMlYkiZYoLEZX6uukJ6TkWCBOiYcqcRdoAI7LohhMo3bBSGSsMShrkENXVPEyCQhsC
 VBuwhVM1MhL8GFLAOPq7w0SGSwDx+IDE4GoyOv00T4lFfTMNvRrX8tCG2hfRg57O3WNI75ET/
 5a/bmLZi+HeOhWSFZqwmdqEoGyGJpkL1EHTBKO9Wo=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Since quite a while I wanted to update the firmware on my good olde
tape drive. However, I do not have any contract all newer HPE downloads
require. Searching the web I stumbled over some old messages [1] and
[2] from Doug Gilbert which paved the way to easily do such firmware
update.

I have an EH957A/EH957B HP StoreEver LTO-5 Ultrium 3000 SAS internal
half-height tape drive which had the standalone Z64D firmware e.g.
reporting the following upon boot (dmesg):

[10062376.346530] scsi 0:0:1:0: Sequential-Access HP       Ultrium 5-
SCSI   Z64D PQ: 0 ANSI: 6
...
[10062376.378197] st 0:0:1:0: Attached scsi generic sg3 type 1

The later message reporting sg3 is important to know for the commands
below.

The non-paywalled firmware is actually available within some EXE file
[3] which may be easily unzipped.

Pages 228 and 229 of the HP LTO Ultrium Tape Drives Technical Reference
Manual Volume 3: Host Interface Guide, LTO 5 drives [4] talks about how
the WRITE BUFFER 3Bh command may be used to update the firmware by
first sending it using mode 4 and then initiating the update using mode
5. Luckily, the sg3_utils come with some convenience tools easily
allowing to do just that:

sudo sg_write_buffer -b 4k -I Z6ED_019_233.E -m 4 /dev/sg3
sudo sg_write_buffer -m 5 /dev/sg3

And - TADA - my drive is updated:

[10067140.872255] scsi 0:0:2:0: Sequential-Access HP       Ultrium 5-
SCSI   Z6ED PQ: 0 ANSI: 6

Thanks Doug Gilbert for the usefull insights into SCSI tape drive
operation details. Keep up the good work!

[1] 
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg69571.html

[2] https://patchwork.kernel.org/patch/7946871/#17063991

[3] 
https://downloads.hpe.com/pub/softlib2/software1/sc-windows/p368283668/v124587/cp031432.exe

[4] 
https://docs.oracle.com/cd/E21419_04/en/LTO5_Vol3_E5b/LTO5_Vol3_E5b.pdf

Cheers

Marcel

