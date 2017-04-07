From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Fri, 7 Apr 2017 21:23:48 +0000
Message-ID: <1491600225.2559.31.camel@sandisk.com>
References: <1491580154-30489-1-git-send-email-bryantly@linux.vnet.ibm.com>
         <0c80c6e3-168a-d8bd-d7b4-e727723bcf18@sandisk.com>
         <5297a130-5349-1796-2fe4-2336daa346ab@linux.vnet.ibm.com>
         <1491583008.2559.12.camel@sandisk.com>
         <63af0be8-f36f-a42d-9898-a7ef642a8c17@linux.vnet.ibm.com>
         <402a3e4d-0466-e315-7981-ce9c240236dc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:3189 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755546AbdDGVXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2017 17:23:51 -0400
In-Reply-To: <402a3e4d-0466-e315-7981-ce9c240236dc@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <10F3693241284947BA56883781ED0C7C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "mikecyr@linux.vnet.ibm.com" <mikecyr@linux.vnet.ibm.com>, "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "seroyer@linux.vnet.ibm.com" <seroyer@linux.vnet.ibm.com>

On Fri, 2017-04-07 at 16:14 -0500, Michael Cyr wrote:
> That then caused this issue, because release_cmd is always called, even=20
> if queue_status is not.  Perhaps it would be cleaner to set some sort of=
=20
> status valid flag during queue_status instead of setting a flag in=20
> aborted_task?

Hello Michael,

Thanks for the clarification. Have you already checked whether a new flag
is really needed or whether checking CMD_T_TAS would be sufficient?

Thanks,

Bart.=
