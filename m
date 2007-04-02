From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Mon, 2 Apr 2007 12:33:11 -0700 (PDT)
Message-ID: <824244.95510.qm@web31801.mail.mud.yahoo.com>
References: <1175278774.3760.44.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1175278774.3760.44.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:

> I'd favour trying to separate kobject and struct device for this ...
> move all the sysfs stuff into kobject and device only stuff into struct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Currently the kobject implementation is pure and well-defined.  It is
a good implementation [kobject], and I'd hate to see it lost into being
convoluted with/into another model.

Currently the infrastructure layers are well defined:
   kobject ->  (A layer with objects, their behavor and implementation)
          device ->   (--"--)
                  sysfs.   (--"--)
This isn't that bad of an infrastructure.

It is this well defined layering, i.e. objects, their behavior and
implementation, that allows different (better/worse) infrastructures
to be built on top of it.

It is this well-defined layering which will allow what Tejun wants
to be implemented.

> device ... but that would get us into disentangling the ksets, which, on
> balance, isn't going to be fun ...

     Luben

