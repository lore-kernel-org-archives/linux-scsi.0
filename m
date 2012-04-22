From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Sun, 22 Apr 2012 19:01:58 -0400
Message-ID: <20120422230156.GA25181@redhat.com>
References: <20120405144721.GA18437@redhat.com>
 <20120420144538.GB8155@redhat.com>
 <20120420173405.GA8846@redhat.com>
 <20120420214120.159e2690@pyramind.ukuu.org.uk>
 <20120420215825.GA10406@redhat.com>
 <20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
 <20120420225822.GA10769@redhat.com>
 <20120421001433.2955abd4@pyramind.ukuu.org.uk>
 <20120422221329.GB24109@redhat.com>
 <20120422233454.7cdd0f35@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab2DVXCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Apr 2012 19:02:11 -0400
Content-Disposition: inline
In-Reply-To: <20120422233454.7cdd0f35@pyramind.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org

Funny thing happens when you assume too much...

Anyway, your no compromises approach is admirable but it doesn't erase
the fact that all proprietary Linux drivers use EXPORT_SYMBOL code.

So what you're really saying is no proprietary drivers are allowed to be
loaded into a Linux kernel.  Nice that you've made this scsi_dh_detach
change the frontline of a battle that has already been lost years ago.

Thanks for your time,
Mike
