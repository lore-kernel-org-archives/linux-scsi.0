From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: qla2xxx errors? (2.6.19)
Date: Tue, 26 Jun 2007 09:31:33 -0500
Message-ID: <1182868293.3562.12.camel@localhost.localdomain>
References: <20070610100011.GG5705@digitus>
	 <20070612174854.GD12266@plap.qlogic.org> <20070621214143.GC29237@digitus>
	 <20070626124640.GO14570@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40284 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754150AbXFZObg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 10:31:36 -0400
In-Reply-To: <20070626124640.GO14570@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Csillag Tamas <cstamas@digitus.itk.ppke.hu>, linux-scsi@vger.kernel.org

On Tue, 2007-06-26 at 05:46 -0700, Andrew Vasquez wrote:
> On Thu, 21 Jun 2007, Csillag Tamas wrote:
> 
> > Hi Andrew,
> > 
> > On 06/12, Andrew Vasquez wrote:
> > ...
> > > I can setup somthing similar locally, I take it you are writing
> > > directly some some lun exported off the DS400, and not using DM?
> > ...
> > 
> > Do you have any results? Does the information I sent regarding my
> > system helped?
> > 
> > Please tell me if you need more information or anything that can help.
> 
> The initial logs don't indicate any 'notable' driver issues during the
> I/O test.  Concurrently, we've been unable to reproduce on similar
> storage along with other array devices.  I've escalated this to our
> formal support group (which should be in contact with you shortly) in
> hopes of triaging this further and getting resolution.

The DS400 is actually a discontinued array ... any chance the original
reproducer could redo the test with an LSI or an Emulex FC adapter just
to see if its qlogic or array related?

James


