From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 6/8] IB/srp: reduce lock coverage of command completion
Date: Mon, 03 Jan 2011 03:44:16 -0500
Message-ID: <1294044256.2600.0.camel@obelisk.thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	 <1293139893-11678-7-git-send-email-dillowda@ornl.gov>
	 <AANLkTikBkdn6XWgJELaBBFi1ZHen+UwQuumDn+yEPDPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikBkdn6XWgJELaBBFi1ZHen+UwQuumDn+yEPDPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-01-02 at 18:27 +0100, Bart Van Assche wrote:
> Before this patch target->req_lim was updated both when receiving a
> response for a regular SRP command and when receiving a response for
> an SRP task management command. This patch modifies that in only
> updating target->req_lim in the former case. Are you sure that's
> correct ?

No, that's a bug. Good catch, thanks.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
