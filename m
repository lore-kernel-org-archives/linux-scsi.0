From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi: require help for one issue about INQUIRY?
Date: Fri, 13 Apr 2012 16:47:15 +0200
Message-ID: <1334328435.3028.39.camel@dabdike>
References: <CAEH94LiE6-QqJowDm+nAT3-g_JOFKBfZ=AW5Thibq5AP93DVAg@mail.gmail.com>
	 <1334328012.3028.37.camel@dabdike>
	 <CAEH94LgkT03amAG3GD-wcfEg+q6S0=h97JkJFwBgdhDTnj1yYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48963 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab2DMOrT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Apr 2012 10:47:19 -0400
In-Reply-To: <CAEH94LgkT03amAG3GD-wcfEg+q6S0=h97JkJFwBgdhDTnj1yYg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2012-04-13 at 22:42 +0800, Zhi Yong Wu wrote:
> On Fri, Apr 13, 2012 at 10:40 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2012-04-13 at 22:30 +0800, Zhi Yong Wu wrote:
> >> HI,
> >>
> >> When one machine was started with one scsi device,the information
> >> below was showed. Does anyone know how to fix this issue?
> >>
> >> "scsi scan: INQUIRY result too short (5), using 36"
> >> "Scsi 2:0:292:0: Direct-Access"
> >
> > Well, it means what it says: the device wrongly returned only 5 bytes
> "using 36" mean that device should return 36 bytes?

The SCSI standard (SPC3) says

        6.4.2 Standard INQUIRY data
        The standard INQUIRY data (see table 81) shall contain at least
        36 bytes.

James


