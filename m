From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Mid-layer API?
Date: Fri, 20 Oct 2006 01:06:17 -0700 (PDT)
Message-ID: <20061020080617.30483.qmail@web31807.mail.mud.yahoo.com>
References: <861B5CF71BC70C478DFEB9EAFE98F699A86E82@G3W0068.americas.hpqcorp.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:49768 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S2992577AbWJTIGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 04:06:18 -0400
In-Reply-To: <861B5CF71BC70C478DFEB9EAFE98F699A86E82@G3W0068.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>, linux-scsi@vger.kernel.org

--- "Haefliger, Juerg" <Juerg.Haefliger@hp.com> wrote:
> I have a kernel driver that needs to send SCSI commands and data to a FC
> disk attached to a Qlogic FC HBA. I'm hooking into the SCSI mid-layer by
> calling scsi_do_req(). It seems to work but I'm not sure if this is the
> right way of doing things. Is scsi_do_req the right entry point into the
> mid-layer or should I use something else? Or should I hook into
> something else than the mid-layer?

Juerg,

The answer to your question depends on the answer to this
question: Who is generating the commands and data,
or loosely where are the commands and data coming from?

Once you've answered this, then you can take a look at who (or what)
is the midlayer servicing.  Sketch that on paper.

Then chart on another sheet of paper the complete path of the
commands and data,  from the origin to the point you want to "send"
them to the FC disk and compare that the above chart.

This will give you the answer of where you're supposed to
"hook into" and why.

Good luck!
    Luben


> And finally, is there any
> documentation talking about the mid-layer API?
> 
> Any help is greatly appreciated.
> 
> Thanks
> ...juerg
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

