From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [RESEND][PATCH] lpfc should check return status for task mgmt
 IOCBs
Date: Wed, 6 Mar 2013 15:44:58 -0600
Message-ID: <5137B8DA.2020106@tributary.com>
References: <5134E5F0.3070905@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:8512 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3CFVpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Mar 2013 16:45:06 -0500
In-Reply-To: <5134E5F0.3070905@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, Linux Scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ping?

Comments, suggestions, rejections for this patch? I understand its a little
long, but it seems checking the return status from a task management routine
could be considered important. Plus, it helps to bring the behavior in line
with the other LLDs.



Thanks,


Jeremy Linton
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRN7jaAAoJEL5i86xrzcy76+sH/2u9V3GJLCgMSB2LAZDDcpAK
4t+Um2IraIJocFvylckJieoMjhfAMcsc8fJzoxvBNVb7g6NvBQZIh2IbiWhBc2Id
3/t9rA5wdbBMAbIYsoxwY1t6laxkwZxxfP3QI5UDf0e5jcd5hg+RKB6PDOD8wLZ3
tsUsDNDic0agY0WiUpied5qh4feO2e6j6Rkv/3uTFQLWIjqZMUhwZEjVivIbfG/m
OWj56HuaHg0CAGq1Gos2ruuzfFuwVr8Eo4SgMlnGQNdENc6R+WbNdzCszKgRCKEt
QPULdPQ2/2GCqjweHeY10OzAlAcxNRH8Z2EMbmJRmJltnwMzVHBxluIbH207MaM=
=6yaT
-----END PGP SIGNATURE-----
