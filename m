From: Michel Wilson <michel@crondor.net>
Subject: sym53c810a gives CACHE TEST FAILED
Date: Fri, 13 Dec 2002 00:03:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212130003.45824.michel@crondor.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda (andromeda.hgd.net [10.0.0.2])
	by aeon.hgd.net (8.12.1/8.12.1) with ESMTP id gBCN3kfV026743
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2002 00:03:46 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I recently blew the dust off my old Digital Alpha XL300, but I couldn't get 
2.4.20 to boot on it. It didn't like my onboard sym53c810a for some reason. 
It says:
CACHE TEST FAILED: DMA error (dstat=0xa0).
CACHE INCORRECTLY CONFIGURED.
with the sym-driver, or with the ncr-driver:
CACHE TEST FAILED: script execution failed.
start-886b3414, pc=886b3414, end=886b3440
CACHE INCORRECTLY CONFIGURED
I remember trying the sym53c8xx-2 driver, but it gave the same message. 
Didn't make a screenshot of that one though, so I don't know the exact 
message.
I did some searching on it, I came across a few people with the same, or 
similar problems, but there weren't any answers...
Does anyone know what I should try next, or how I can get more debugging 
info on this? It must be a driver problem, the card works fine onder 
2.2.7...

Regards,

Michel Wilson.
- -- 
Eagles may soar, but weasels don't get sucked into jet engines.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9+RXRL2ru+9LLS34RAowvAKDBuHb6updCPHEDOjNLZA3SXBtiKQCcC6TB
lfo3qSdFw46h3zkR1L0AYTs=
=UO0M
-----END PGP SIGNATURE-----

