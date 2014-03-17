From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH v2 11/13] SCSI/libiscsi: Add check_protection callback
 for transports
Date: Mon, 17 Mar 2014 11:59:09 -0500
Message-ID: <532729DD.1040506@cs.wisc.edu>
References: <1394041431-28399-1-git-send-email-sagig@mellanox.com> <1394041431-28399-12-git-send-email-sagig@mellanox.com> <CAJZOPZ+DtO7AqMgFJqm7uz2zwxk5Gs__J10qHhwB0RbAxzYTkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+DtO7AqMgFJqm7uz2zwxk5Gs__J10qHhwB0RbAxzYTkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <MChristie-5c4llco8/ftWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 03/17/2014 02:25 AM, Or Gerlitz wrote:
> On Wed, Mar 5, 2014 at 7:43 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> >
>> > iSCSI needs to be at least aware that a task involves protection
>> > information. In case it does, after the transaction completed
>> > libiscsi will ask the transport to check the protection status
>> > of the transaction.
>> >
>> > Unlike transport errors, DIF errors should not prevent successful
>> > completion of the transaction from the transport point of view,
>> > but should be escelated to scsi mid-layer when constructing the
>> > scsi result and sense data.
>> >
>> > check_protection routine will return the ascq corresponding to the
>> > DIF error that occured (or 0 if no error happened).
>> >
>> > return ascq:
>> > - 0x1: GUARD_CHECK_FAILED
>> > - 0x2: APPTAG_CHECK_FAILED
>> > - 0x3: REFTAG_CHECK_FAILED
> Hi Mike, just to remove doubt, this patch is OK with you, right? can
> you please ack it, so we know we're all good for the 3.15 merge window
> 

This patch is ok, but happened to the patch for the xmit task path?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
