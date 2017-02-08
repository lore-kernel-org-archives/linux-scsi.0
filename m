From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/5] target: Don't BUG_ON during NodeACL dynamic ->
 explicit conversion
Date: Wed, 08 Feb 2017 08:16:20 -0800
Message-ID: <1486570580.7066.7.camel@haakon3.risingtidesystems.com>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
         <1486473470-15837-2-git-send-email-nab@linux-iscsi.org>
         <20170207224453.GB5274@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207224453.GB5274@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-02-07 at 14:44 -0800, Christoph Hellwig wrote:
> On Tue, Feb 07, 2017 at 01:17:46PM +0000, Nicholas A. Bellinger wrote:
> > +		if (orig->se_lun_acl != NULL) {
> > +			pr_warn_ratelimited("Detected existing explicit"
> > +				" se_lun_acl->se_lun_group reference for %s"
> > +				" mapped_lun: %llu, ignoring\n",
> > +				 nacl->initiatorname, mapped_lun);
> 
> The ignoring in the message confused the heck out of me first.  But it 
> seems that's just an incorrect leftover from the original message, as the
> changelog also says fail instead.  With that fixed up (and maybe the
> whole message in a single string literal on a single line):
> 

Fixed up the message to use 'failed'.
