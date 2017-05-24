From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 05/15] qedf: Check that fcport is offloaded before
 dereferencing pointers in initiate_abts|cleanup.
Date: Wed, 24 May 2017 16:25:28 +0000
Message-ID: <1495643128.2823.18.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-6-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:45936 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967288AbdEXQZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:25:31 -0400
In-Reply-To: <20170523131931.1777-6-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <FD04C6EE16E63B40A7256CEA88CCCC4D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> If an fcport is not offloaded then the members of the qedf_rport struct
> are undefined which may cause a system crash.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
