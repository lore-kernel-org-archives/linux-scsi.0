From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH]: megaraid 2.20.4: Fixes a data corruption bug
Date: 01 Oct 2004 16:43:52 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1096663438.1766.97.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230C986@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S266488AbUJAUv0@vger.kernel.org>
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230C986@exa-atlanta>
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2004-10-01 at 16:32, Bagalkote, Sreenivas wrote:
> Without CONFIG_COMPAT around them, I get "unresolved symbol"
> for (un)register_ioctl32_conversion while loading the module.

Not in the latest -bk or -mm kernels if you check.  The primitives to
allow this were added to include/linux/ioctl32.h

James
