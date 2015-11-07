From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: SCST 3.1 pre-release freeze
Date: Fri, 06 Nov 2015 20:18:57 -0800
Message-ID: <563D7BB1.2010600@vlnb.net>
References: <563C4D1A.30102@vlnb.net> <CALAS2kmDLoSBebryAOfCREWsM9kGrEakWQ8G8WK-dK2oAz9sSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALAS2kmDLoSBebryAOfCREWsM9kGrEakWQ8G8WK-dK2oAz9sSg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bike & Snow <bikeandsnow@googlemail.com>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Bike & Snow wrote on 11/06/2015 10:55 AM:
> Hello Vlad
> 
> Excellent news on all the updates.
> 
> Regarding this:
> - QLogic target driver has been significantly improved.
> 
> Does that mean I should stop building the QLogic target driver from here?
> git://git.qlogic.com/scst-qla2xxx.git <http://git.qlogic.com/scst-qla2xxx.git>
> 
> Or are you saying the git.qlogic.com <http://git.qlogic.com> has been improved?

It is saying that qla2x00t was improved.

The ultimate goal is to have the mainstream (git) QLogic target driver to be the main
and the only QLogic target driver, but, unfortunately, this driver not yet reached
level of quality and maturity of qla2x00t. We with QLogic are working toward it.

> If I stop building the one from git.qlogic.com <http://git.qlogic.com>, does the 3.2.0
> one support NPIV?

Yes, it has full NPIV support.

Vlad
