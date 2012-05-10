From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] qla2xxx: Add missing call to qlt_fc_port_deleted()
Date: Thu, 10 May 2012 14:07:39 -0700
Message-ID: <CAL1RGDW-7Sv+mpm=vsb4Fccxw_hD-VZZ71+1VQ1goYDEPd67cA@mail.gmail.com>
References: <1336585861-23603-1-git-send-email-roland@kernel.org> <1336596536.31443.154.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1336596536.31443.154.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Arun Easi <arun.easi@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

> This might end up explaining one of the issues encountered on 3.4-rc1
> code with qla83xx HW on physical link failure, namely the
> 'Kobject crash during libfc rport reset' bug that was originally looking
> like:

No, I don't think this is related.  I've never seen that, but forgetting
to mark a session for deletion I don't think has any effect on any
kobject lifetimes or anything that looks involved here.

I've been stuck running qla_target stuff backported to a 2.6.39
kernel, possibly some newer changes to the surrounding kernel
are involved here.

 - R.
