From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 14:31:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F57BF1.4010001@pobox.com>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se> <40F556CE.9000707@pobox.com> <20040714164253.GE7308@fs.tum.de> <40F562FC.50806@pobox.com> <20040714165419.GF7308@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21958 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265161AbUGNSb2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 14:31:28 -0400
In-Reply-To: <20040714165419.GF7308@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@fs.tum.de>, Mikael Pettersson <mikpe@csd.uu.se>, akpm@osdl.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org

Also, it would probably be better for some of these changes to simply be 
made non-inline.

	Jeff



