From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 14:44:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F57EF6.5030702@pobox.com>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se> <40F562FC.50806@pobox.com> <20040714165419.GF7308@fs.tum.de> <200407141931.12249.bzolnier@elka.pw.edu.pl> <20040714183335.GG7308@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:26317 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267459AbUGNSoT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 14:44:19 -0400
In-Reply-To: <20040714183335.GG7308@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, viro@parcelfarce.linux.theplanet.co.uk, Mikael Pettersson <mikpe@csd.uu.se>, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Your patch looks OK to me...

