From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 16:17:48 +0100
Message-ID: <4AF19B1C.9000406@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:35028 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZKDPRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 10:17:46 -0500
In-Reply-To: <4AF17AD3.6060909@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

John Hughes wrote:
> Like Lars T=E4uber last year I have a Promise Vtrak J610S "just a bun=
ch=20
> of disks" cabinet, and like him I find that the ses enclosure service=
s=20
> don't seem to be working right.
The problem may not be related to the Promise box, in the same machine =
I=20
have a built-in enclosure (It's a Dell R710):

[    1.461216] scsi 0:0:32:0: Enclosure         DP       BACKPLANE     =
   1.07 PQ: 0 ANSI: 5
[    1.472957] scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i       =
  1.21 PQ: 0 ANSI: 5
[    1.492211] sd 0:2:0:0: [sda] 285474816 512-byte logical blocks: (14=
6 GB/136 GiB)
[    1.492299] sd 0:2:0:0: [sda] Write Protect is off
[    1.492302] sd 0:2:0:0: [sda] Mode Sense: 1f 00 10 08
[    1.492354] sd 0:2:0:0: [sda] Write cache: disabled, read cache: ena=
bled, supports DPO and FUA
[    1.492564]  sda: sda1 sda2 sda3 sda4
[    1.493167] sd 0:2:0:0: [sda] Attached SCSI disk


But when I look in /sys/class/enclosure/0:0:32:0 I find no devices, and=
=20
in /sys/block/sda/device I see no trace of the enclosure.

This is with 2.6.31.


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
