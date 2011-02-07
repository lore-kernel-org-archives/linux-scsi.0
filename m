From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Why using configfs as the only interface is wrong for a
 storage target
Date: Mon, 7 Feb 2011 14:53:01 -0800
Message-ID: <20110207225300.GD13518@noexit>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
 <20110207115347.GA7503@noexit>
 <1297089709.3012.19.camel@mulgrave.site>
 <20110207160223.598210a2@harpe.intellique.com>
 <1297109379.13752.250.camel@haakon2.linux-iscsi.org>
 <20110207223845.71d2ab18@galadriel2.home>
 <20110207224407.GC13518@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51496 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab1BGWxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 17:53:08 -0500
Content-Disposition: inline
In-Reply-To: <20110207224407.GC13518@noexit>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, Bart Van Assche <bvanassche@acm.org>

On Mon, Feb 07, 2011 at 02:44:09PM -0800, Joel Becker wrote:
> 	It's great that Nick has fancy tools to fly around the target
> configfs space, but that's all fluff for people writing and debugging

	I'm glad that Nick is excited about what configfs provides him
as a developer examining the system, but I think he goes overboard
extolling these virtues.  This distracts from the core discussion of
configfs as a method of communicating the configuration to kernelspace.

Joel

-- 

Life's Little Instruction Book #207

	"Swing for the fence."

			http://www.jlbec.org/
			jlbec@evilplan.org
