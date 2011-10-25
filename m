From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH-v2] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Tue, 25 Oct 2011 08:00:13 +0200
Message-ID: <CAO+b5-oF=BB0YeTAMFqCwVUE7C2aC9z15tRiqQdcZ6nVpmTKrA@mail.gmail.com>
References: <1319435841-19046-1-git-send-email-nab@linux-iscsi.org>
 <CAO+b5-rch-mPgXKjs4=t4ubfb9SFhDiR26EoeJgyZjWfhRJ9DA@mail.gmail.com> <1319481232.17450.11.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56306 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1JYGAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2011 02:00:34 -0400
In-Reply-To: <1319481232.17450.11.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Oct 24, 2011 at 8:33 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> It would have been nice if you bothered to mention these in any of the
> pre merge window reviews, but given your delay responsed on these items
> they will have to be something we'll fix post merge.

Sorry for that - it took some time though before I remembered myself
about all this.

If you are looking for a test case: pulling an IB cable during I/O a
few times should allow to trigger this.

Bart.
