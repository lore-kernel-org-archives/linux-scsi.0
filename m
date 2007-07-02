From: Csillag Tamas <cstamas@digitus.itk.ppke.hu>
Subject: Re: qla2xxx errors? (2.6.19)
Date: Mon, 2 Jul 2007 23:40:11 +0000
Message-ID: <20070702234010.GJ13779@digitus>
References: <20070610100011.GG5705@digitus> <20070612174854.GD12266@plap.qlogic.org> <20070621214143.GC29237@digitus> <20070626124640.GO14570@plap.qlogic.org> <1182868293.3562.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jugis.itk.ppke.hu ([193.225.109.42]:33710 "EHLO
	jugis.itk.ppke.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbXGBXkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jul 2007 19:40:31 -0400
Content-Disposition: inline
In-Reply-To: <1182868293.3562.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

On 06/26, James Bottomley wrote:
> On Tue, 2007-06-26 at 05:46 -0700, Andrew Vasquez wrote:
> > On Thu, 21 Jun 2007, Csillag Tamas wrote:
> > > Hi Andrew,
> > > 
> > > On 06/12, Andrew Vasquez wrote:
> > > ...
> > > > I can setup somthing similar locally, I take it you are writing
> > > > directly some some lun exported off the DS400, and not using DM?
> > > ...
> > > 
> > > Do you have any results? Does the information I sent regarding my
> > > system helped?
> > > 
> > > Please tell me if you need more information or anything that can help.
> > 
> > The initial logs don't indicate any 'notable' driver issues during the
> > I/O test.  Concurrently, we've been unable to reproduce on similar
> > storage along with other array devices.  I've escalated this to our
> > formal support group (which should be in contact with you shortly) in
> > hopes of triaging this further and getting resolution.
> 
> The DS400 is actually a discontinued array ... any chance the original
> reproducer could redo the test with an LSI or an Emulex FC adapter just
> to see if its qlogic or array related?

Well. I do not have any other card right now. The problem only appears
with kernel version > 2.6.18. So I do not think that this is array
related.

If you say it is worth trying with other cards I will try to borrow one,
but please confirm first as it is not easy for me to get one.

Thanks.

Best regards,
cstamas
-- 
CSILLAG Tamas (cstamas) - http://digitus.itk.ppke.hu/~cstamas

