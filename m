From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [RFC 01/11] iscsi-target: Add iscsit_transport API template
Date: Thu, 07 Mar 2013 22:02:30 -0800
Message-ID: <1362722550.7905.290.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
	 <CAG4TOxM=PDYXCAMNdRx629aAP+XF7oZmykg0k4b+a688PzzayA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxM=PDYXCAMNdRx629aAP+XF7oZmykg0k4b+a688PzzayA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-03-07 at 20:14 -0800, Roland Dreier wrote:
> On Thu, Mar 7, 2013 at 5:45 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > +EXPORT_SYMBOL(iscsit_get_transport);
> 
> It's not clear to me why this needs to be exported.  Who would use it
> outside the core iscsi target module?

Oversight on my part.  Dropping the unnecessary export of
iscsit_get_transport() and iscsit_put_transport() from iscsi-target code
now..

Also, realistically, I don't expect module code beyond ib_isert.ko to
ever use the definitions in include/target/iscsi/ either.

Or and I discussed this point in the last status call, and given what
the initiator did originally (eg: export iscsi_transport) he asked to
keep it under drivers/infiniband/ulp/isert/ with the extra include bits.

I'd have a slight preference to move iser-target code under
drivers/target/iscsi/, and not put anything into include/target/iscsi/
if there won't be another module that uses it..

Do you have a preference here..?

--nab






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
