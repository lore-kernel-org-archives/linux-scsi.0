From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi/libata: Support variable-length cdb of ata
 pass-thru(32).
Date: Fri, 23 Jun 2017 18:13:12 +0000
Message-ID: <1498241591.2735.13.camel@wdc.com>
References: <1497697243-3724-1-git-send-email-dn3108@gmail.com>
         <1498071149.2746.26.camel@wdc.com>
         <CAKv8XUU-k0dFjHAu9G2rM+is4AZw9BKfsFDh1zG0zwq=GzSVkg@mail.gmail.com>
         <1498238136.2735.8.camel@wdc.com>
         <CAKv8XUWxJUxaWzJmJeSuOj7i7tv4_3w=iYmnNyxxGYXwnMwy4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:14807 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754448AbdFWSNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 14:13:16 -0400
In-Reply-To: <CAKv8XUWxJUxaWzJmJeSuOj7i7tv4_3w=iYmnNyxxGYXwnMwy4g@mail.gmail.com>
Content-Language: en-US
Content-ID: <7B10F4D819327446B1A27A37E5522D9F@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dn3108@gmail.com" <dn3108@gmail.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On Sat, 2017-06-24 at 02:59 +0900, Minwoo Im wrote:
> I completely agree with you. ATA_32 was moved to variable length command =
list.

Thanks for having addressed all my comments. Since as far as I'm familiar
with SCSI / ATA translation this patch looks fine to me, feel free to add

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Please note the following:
- You will have to repost this patch with a proper description and as a
  separate e-mail. See also
  https://www.kernel.org/doc/Documentation/process/5.Posting.rst
- The maintainer for the libata subsystem is Tejun Heo so you will need his
  approval before this patch can be merged.

Bart.=
