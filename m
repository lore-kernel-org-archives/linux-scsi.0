From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC]: Mainline of TCM Core and TCM_Loop for v2.6.35
Date: Sun, 30 May 2010 20:47:04 -0700
Message-ID: <1275277624.32585.88.camel@haakon2.linux-iscsi.org>
References: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>
	 <87vda5zqm9.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vda5zqm9.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas@firstfloor.org, Gilbe@firstfloor.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-05-30 at 11:27 +0200, Andi Kleen wrote:
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> writes:
> >
> > As always, I am open to constructive suggestions,
> 

Greetings Andi,

> Your description contains quite a lot of acronyms (I count 8 in the first
> paragraph alone). For the benefit of the linux-kernel audience which are
> not storage experts and are struggling to find out what this is all good
> for, how about including a glossary that explains what it all means?  I
> suspect having that in the git commit log later will be also useful.
> 

Point taken on a glossary + storage decoder ring..  Being able to open
up the discussion to a wider kernel audience is a really good thing I
think. ;)

Also, one major item on my TODO list is to publish a fabric plugin
'cookbook' for creating your very own TCM target mode fabric module with
a fully functioning configfs control plane.  This will initially involve
a walkthough of the required logic to get up and running for new fabric
module developers.

However, what I would like to eventually do with the mainline TCM code
is to provide a single example fabric module + script for generating N
new base TCM fabric modules with a fully functioning v4 configfs fabric
shell.  This script would generate code with sed-fu based on a supplied
fabric plugin name and supported SCSI ProtocolIDs (eg: SAS, FC, iSCSI,
etc) using existing TCM v4 world wide port name (WWPN) emulation logic
located in drivers/target/target_core_fabric_lib.c.

The latter WWPN emulation bit is what allows SPC-4 features like
persistent reservation (PR), asymmetric logical unit access (ALUA) to
work right out of the box for a newly generated TCM v4 fabric plugin
today.  This is what has been included in new base code for tcm_lpfc,
tcm_qla2xxx and tcm_mvsas modules and recently posted to linux-scsi.

Anyways, the ability generate a base kernel fabric module you can
actually build, load and configure it's new TCM configfs fabric shell
would be pretty cool and would certainly be a big help for new
developers too.

Thanks for your comments Andi!

Best,

--nab
