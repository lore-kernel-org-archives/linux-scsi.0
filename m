From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v4.3-rc7] be2iscsi : Fix bogus WARN_ON length check
Date: Fri, 30 Oct 2015 21:59:22 +0100
Message-ID: <mqdbnbgxec5.fsf@linux-x5ow.site>
References: <1446229378-2956-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446229378-2956-1-git-send-email-tim.gardner@canonical.com> (tim
	gardner's message of "Fri, 30 Oct 2015 12:22:58 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: tim.gardner@canonical.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Minh Tran <minh.tran@avagotech.com>, John Soni Jose <sony.john-n@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tim,
tim.gardner@canonical.com writes:

> From: Tim Gardner <tim.gardner@canonical.com>
>
> drivers/scsi/be2iscsi/be_main.c: In function 'be_sgl_create_contiguous':
> drivers/scsi/be2iscsi/be_main.c:3187:18: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
>   WARN_ON(!length > 0);
>
> gcc version 5.2.1

This patch (or similar) was already posted on Oct 1 by Joel Stanley.
See http://comments.gmane.org/gmane.linux.scsi/105462

Thanks,
        Johannes
