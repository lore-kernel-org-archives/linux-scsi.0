From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] qla2xxx: Return the fabric command state for non-task
 management requests
Date: Fri, 24 Jul 2015 23:29:26 -0700
Message-ID: <20150725062926.GC26437@infradead.org>
References: <1437516477-30554-3-git-send-email-sbaugh@catern.com>
 <20150723094651.GA15301@infradead.org>
 <CAGxsngq1aBCoqmdSZcX+o=Ef=NyQSeunqDQuo2iwgmOAxsEqDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGxsngq1aBCoqmdSZcX+o=Ef=NyQSeunqDQuo2iwgmOAxsEqDw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Dilip Uppugandla <dilip@purestorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, Spencer Baugh <sbaugh@catern.com>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:QLOGIC QLA2XXX FC-SCSI DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Which debug printk do you care about?  I'd much prefer having a trace
point inside the driver which could even pretty print it instead of the
hack where a driver defined binary value is printed by the core.
