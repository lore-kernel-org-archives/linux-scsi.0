From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] SAS domain layout for Linux sysfs
Date: Tue, 26 Apr 2005 11:18:07 -0400
Message-ID: <426E5BAF.4040003@adaptec.com>
References: <425D392F.2080702@adaptec.com> <20050424111908.GA23010@infradead.org> <426D1572.70508@adaptec.com> <20050425161411.GA11938@infradead.org> <426D2723.8070308@adaptec.com> <20050425181831.GA14190@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:18903 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261568AbVDZPVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2005 11:21:16 -0400
In-Reply-To: <20050425181831.GA14190@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, andrew.patterson@hp.com, Eric.Moore@lsil.com, mike.miller@hp.com, dougg@torque.net, Madhuresh_Nagshain@adaptec.com

On 04/25/05 14:18, Christoph Hellwig wrote:
> The point is that discovery must happen for each HBA separately because
> we absolutely do not want to have global state.

OK.

Can you please define "global state"?

In SAS, when the domain changes, the controller(s) connected to the
domain get notification and pass it to the discovery process, which
will run again.

Overall, since the discovery process gets (internally) a "picture"
of the domain out there, it would be appropriate to show this
"picture" to the user.

	Luben
