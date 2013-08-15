From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Thu, 15 Aug 2013 09:45:19 -0700
Message-ID: <CAL1RGDVktaz4Y4_bB+uTzjk0R1+RgwF7DNuZ_+zvpLvH90oTQA@mail.gmail.com>
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com>
 <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:58988 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757521Ab3HOQpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Aug 2013 12:45:40 -0400
Received: by mail-ob0-f179.google.com with SMTP id fb19so1088951obc.38
        for <linux-scsi@vger.kernel.org>; Thu, 15 Aug 2013 09:45:39 -0700 (PDT)
In-Reply-To: <52025BE3.5020002@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, James Bottomley <JBottomley@parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Jeffery <djeffery@redhat.com>

Jens / James, do you guys plan to send this to Linus for 3.11?
Triggering this bug is a bit esoteric but the impact is pretty nasty
(corrupting an unrelated process).

Thanks,
  Roland
