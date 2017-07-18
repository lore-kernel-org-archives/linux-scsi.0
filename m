From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction before starting the request) breaks mtx tape library control
Date: Tue, 18 Jul 2017 11:53:29 -0500
Message-ID: <ufashhtadpy.fsf@epithumia.math.uh.edu>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
        <20170718073747.GD4875@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170718073747.GD4875@linux-x5ow.site> (Johannes Thumshirn's
        message of "Tue, 18 Jul 2017 09:37:47 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "JT" == Johannes Thumshirn <jthumshirn@suse.de> writes:

JT> This is fixed with: commit 68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47

Hmm, well, I just pulled and built mainline, which does appear to
contain that patch (though it wasn't there when I first started
investigating this last week) and the problem is still there.  I'll try
building clean 4.12 and applying just that patch over the top.

 - J<
