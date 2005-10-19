From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Wed, 19 Oct 2005 20:18:03 +0200
Message-ID: <1129745884.2822.40.camel@laptopd505.fenrus.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
	 <20051013231614.27191.9897.sendpatchset@plap.qlogic.com>
	 <1129275031.2873.3.camel@laptopd505.fenrus.org>
	 <20051014162701.GA19098@plap.qlogic.org>
	 <1129315644.5359.7.camel@laptopd505.fenrus.org>
	 <20051019173707.GO9087@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28108 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751177AbVJSSSL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 14:18:11 -0400
In-Reply-To: <20051019173707.GO9087@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Arun Mittal <arun.mittal@qlogic.com>

On Wed, 2005-10-19 at 10:37 -0700, Andrew Vasquez wrote:
> On Fri, 14 Oct 2005, Arjan van de Ven wrote:
> 
> > If you want the firmware issue improved, make the *firmware* BSD
> > licensed. And only the firmware. But leave the driver GPL.
> > And probably make it optional and allow a request_firmware() interface
> > as well, so that people/distributions who don't want the built in one
> > can use the request_firmware() option instead.
> 
> Here's the updated license we'd like to propose.  Please note the
> verbiage regarding the questionable relicensing of the driver codes
> has been removed.


I'm fine with this "license the driver GPL as before, license the
firmware BSD" approach.


