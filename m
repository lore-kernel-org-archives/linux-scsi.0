From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Tue, 27 Jun 2017 06:07:39 +0000
Message-ID: <1498543657.8902.1.camel@wdc.com>
References: <20170616082755.22832-1-hch@lst.de>
         <1498143933.6002.18.camel@suse.com> <1498479220.8799.0.camel@wdc.com>
         <1498491078.8799.2.camel@wdc.com> <1498503349.27347.15.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:25299 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdF0GHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 02:07:43 -0400
In-Reply-To: <1498503349.27347.15.camel@suse.com>
Content-Language: en-US
Content-ID: <B4E07CBA5371C34CABBFA3AE9A71788C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mwilck@suse.com" <mwilck@suse.com>

On Mon, 2017-06-26 at 20:55 +0200, Martin Wilck wrote:
> I personally find it odd that the compile-time choice goes away while
> the run-time choice remains available. I understand what Christoph is
> trying to achieve, but if it was up to me, I'd prefer to change the
> default and mark the "n" setting as deprecated.

Hello Martin,

Although I'm not sure of this I think Christoph wants to remove the config
option to make sure that scsi-mq becomes the default on any Linux distro
that uses a kernel in which this patch has been integrated. Unless someone
comes up with a better alternative I don't think there is a better approach
to achieve this than removing the config option?

Bart.=
