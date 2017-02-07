From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] target: Don't BUG_ON during NodeACL dynamic ->
 explicit conversion
Date: Tue, 7 Feb 2017 14:44:53 -0800
Message-ID: <20170207224453.GB5274@infradead.org>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
 <1486473470-15837-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486473470-15837-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 07, 2017 at 01:17:46PM +0000, Nicholas A. Bellinger wrote:
> +		if (orig->se_lun_acl != NULL) {
> +			pr_warn_ratelimited("Detected existing explicit"
> +				" se_lun_acl->se_lun_group reference for %s"
> +				" mapped_lun: %llu, ignoring\n",
> +				 nacl->initiatorname, mapped_lun);

The ignoring in the message confused the heck out of me first.  But it 
seems that's just an incorrect leftover from the original message, as the
changelog also says fail instead.  With that fixed up (and maybe the
whole message in a single string literal on a single line):

Reviewed-by: Christoph Hellwig <hch@lst.de>
