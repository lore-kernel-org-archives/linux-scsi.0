From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 14:34:20 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <40F57CAC.3030003@pobox.com>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se> <40F562FC.50806@pobox.com> <20040714165419.GF7308@fs.tum.de> <200407141931.12249.bzolnier@elka.pw.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S267498AbUGNSeo@vger.kernel.org>
In-Reply-To: <200407141931.12249.bzolnier@elka.pw.edu.pl>
To: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Adrian Bunk <bunk@fs.tum.de>, Mikael Pettersson <mikpe@csd.uu.se>, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> I still would like somebody to comment on idea of converting sg.c
> to use standard inlines from <linux/time.h> ...


I agree this should be done...

	Jeff
