From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH]: megaraid 2.20.4: Fixes a data corruption bug
Date: 01 Oct 2004 19:09:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096672161.1766.127.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230C989@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41886 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266810AbUJAXJ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 19:09:29 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230C989@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>

On Fri, 2004-10-01 at 18:52, Bagalkote, Sreenivas wrote:
> Would you please send us your version of megaraid driver that will
> most likely go into 2.6.9? We would like baseline your version and
> make our internal releases off of that. I appreciate your help.

You can get my tree in bitkeeper here

bk://linux-scsi.bkbits.net/scsi-misc-2.6

Or, you can get it (with a slight time lag) in the -mm tree:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/

James


