From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Tue, 17 May 2005 14:50:31 -0500
Message-ID: <1116359432.4989.48.camel@mulgrave>
References: <20050516085832.GA9558@gmail.com>
	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>
	 <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com>
	 <1116354894.4989.42.camel@mulgrave>  <20050517192636.GB9121@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29655 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261309AbVEQTvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 15:51:38 -0400
In-Reply-To: <20050517192636.GB9121@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-05-17 at 21:26 +0200, Gr=E9goire Favre wrote:
> Well, it don't... I send you a private mail with a picture I take a b=
oot
> time.

Right, but the problem I think it will fix is the initial inquiry being
sent with the wrong transport parameters.

You have a different problem, I think ... it looks like your Toshiba DV=
D
does somthing strange during Domain Validation ... the question I don't
have an answer to yet, is what.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
