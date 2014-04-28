From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: two small scsi fixes for 3.15-rc3
Date: Mon, 28 Apr 2014 06:58:05 -0700
Message-ID: <1398693485.2419.7.camel@dabdike.int.hansenpartnership.com>
References: <1398424190-21325-1-git-send-email-hch@lst.de>
	 <1398438048.2159.5.camel@dabdike.int.hansenpartnership.com>
	 <20140428090309.GA6571@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140428090309.GA6571@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-04-28 at 11:03 +0200, Christoph Hellwig wrote:
> On Fri, Apr 25, 2014 at 08:00:48AM -0700, James Bottomley wrote:
> > You should have received my git tree emails that they were already in
> > SCSI fixes ... didn't you?  I certainly got a copy.
> 
> I've not seen a single reply to the patches either in my inbox or on
> linux-scsi.

Well, it might be a bit late to trace what went wrong, but these are the
transfer logs with msgid and remote ack.

Apr 19 13:59:31 bedivere amavis[17271]: (17271-15) Passed CLEAN {RelayedOpenRelay}, <jejb@bedivere.hansenpartnership.com> -> <hch@lst.de>,<JBottomley@Parallels.com>,<joe.lawrence@stratus.com>, Message-ID: <20140419205930.1DD598EE0C5@bedivere.hansenpartnership.com>, mail_id: ZmsodClKD9Uy, Hits: -, size: 1796, queued_as: BC8688EE1B6, 663 ms
Apr 19 13:59:33 bedivere postfix/smtp[4861]: BC8688EE1B6: to=<hch@lst.de>, relay=verein.lst.de[213.95.11.211]:25, delay=2.6, delays=0.3/0.05/1.9/0.37, dsn=2.0.0, status=sent (250 2.0.0 Ok: queued as E31ED14564)
Apr 19 13:59:31 bedivere amavis[19335]: (19335-15) Passed CLEAN {RelayedOpenRelay}, <jejb@bedivere.hansenpartnership.com> -> <linux@eikelenboom.it>,<hch@lst.de>,<JBottomley@Parallels.com>, Message-ID: <20140419205930.4C52A8EE0A9@bedivere.hansenpartnership.com>, mail_id: 1_YssH8P_WCo, Hits: -, size: 1796, queued_as: D5D558EE213, 473 ms
Apr 19 13:59:33 bedivere postfix/smtp[4865]: D5D558EE213: to=<hch@lst.de>, relay=verein.lst.de[213.95.11.211]:25, delay=2.9, delays=0.28/0.14/2.1/0.36, dsn=2.0.0, status=sent (250 2.0.0 Ok: queued as 31924145CD)

James


> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
