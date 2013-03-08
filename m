From: Roland Dreier <roland@kernel.org>
Subject: Re: [RFC 01/11] iscsi-target: Add iscsit_transport API template
Date: Fri, 8 Mar 2013 08:59:21 -0800
Message-ID: <CAL1RGDVfCEkpJFJbOjrkznsQUo6jpONNx1HZGbaeRPmdpUVeuQ@mail.gmail.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
 <1362707116-31406-2-git-send-email-nab@linux-iscsi.org> <CAG4TOxM=PDYXCAMNdRx629aAP+XF7oZmykg0k4b+a688PzzayA@mail.gmail.com>
 <1362722550.7905.290.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:42497 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934460Ab3CHQ7o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Mar 2013 11:59:44 -0500
Received: by mail-wi0-f199.google.com with SMTP id hq4so801528wib.6
        for <linux-scsi@vger.kernel.org>; Fri, 08 Mar 2013 08:59:42 -0800 (PST)
In-Reply-To: <1362722550.7905.290.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Thu, Mar 7, 2013 at 10:02 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Or and I discussed this point in the last status call, and given what
> the initiator did originally (eg: export iscsi_transport) he asked to
> keep it under drivers/infiniband/ulp/isert/ with the extra include bits.
>
> I'd have a slight preference to move iser-target code under
> drivers/target/iscsi/, and not put anything into include/target/iscsi/
> if there won't be another module that uses it..
>
> Do you have a preference here..?

It's not really something that matters to me.

 - R.
