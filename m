From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [RFC PATCH 35/35] Add Xen virtual block device driver.
Date: Fri, 24 Mar 2006 16:47:26 -0800
Message-ID: <adaveu3fizl.fsf@cisco.com>
References: <A95E2296287EAD4EB592B5DEEFCE0E9D4B9E8A@liverpoolst.ad.cl.cam.ac.uk>
	<4421D943.1090804@garzik.org>
	<1143202673.18986.5.camel@localhost.localdomain>
	<4423E853.1040707@garzik.org> <4423F60B.6020805@garzik.org>
	<1143207657.2882.65.camel@laptopd505.fenrus.org>
	<4423F91F.4060007@garzik.org>
	<17444.4455.240044.724257@hound.rchland.ibm.com>
	<442442CB.4090603@cs.wisc.edu>
	<17444.18012.796603.193315@hound.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:24865 "EHLO
	sj-iport-4.cisco.com") by vger.kernel.org with ESMTP
	id S1751320AbWCYAre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 19:47:34 -0500
In-Reply-To: <17444.18012.796603.193315@hound.rchland.ibm.com> (Dave C. Boutcher's message of "Fri, 24 Mar 2006 13:19:56 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave C Boutcher <boutcher@cs.umn.edu>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Ian Pratt <m+Ian.Pratt@cl.cam.ac.uk>, Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, Ian Pratt <ian.pratt@xensource.com>, ian.pratt@cl.cam.ac.uk, SCSI Mailing List <linux-scsi@vger.kernel.org>

    Dave> And yeah, I'm aware that there is another SRP implementation
    Dave> in the kernel...Merging would be good...

Changing the ibmvscsi driver to use the include/scsi/srp.h header file
at least is on my list of things to do.  Probably a 2.6.18 type of thing.

 - R.
