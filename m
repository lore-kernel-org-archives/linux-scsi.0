From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Thu, 06 Jan 2005 09:42:04 -0500
Message-ID: <1105022524.4319.23.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57058C01B2@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262845AbVAFOnU@vger.kernel.org>
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57058C01B2@exa-atlanta>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, Matt Domsch <Matt_Domsch@Dell.com>, "'Salyzyn, Mark'" <mark_salyzyn@adaptec.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, Andrew Morton <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-01-06 at 09:20 -0500, Mukker, Atul wrote:
> For this to happen, the applications must at lease know 'n' in host<n>,
> otherwise it will have to trigger a rescan on all controllers. Which would
> be an overkill. How about publishing the adapter class attribute as well?
> This would allow applications to correlate the adapter handle with the class
> attribute.

I don't see why not ... it's your driver, you can publish whatever extra
information you need as scsi_device attributes; that was one of the
designs of the extensible attribute system.

> Apologize for the late post, we were evaluating your feedback. It looks
> good, thanks!

Great ... so the problem is now solved and just needs to be implemented.

James
