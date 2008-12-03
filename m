From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [PATCH] [Target_Core_Mod/PSCSI]: Use struct request to struct scsi_device->request_queue
Date: Wed, 3 Dec 2008 08:19:38 +0100
Message-ID: <e2e108260812022319n1b4363cai86ca0caafb5839aa@mail.gmail.com>
References: <1228265348.6229.130.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:64893 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYLCHTj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 02:19:39 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2396015fgg.17
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2008 23:19:38 -0800 (PST)
In-Reply-To: <1228265348.6229.130.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Dec 3, 2008 at 1:49 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>  drivers/lio-core/target_core_pscsi.c |  206 +++++++++++++++++++++++++---------
>  drivers/lio-core/target_core_pscsi.h |    5 +-
>  drivers/scsi/scsi_lib.c              |    6 +-

Patches that contain changes for multiple subsystems must be split and
submitted separately. E.g. the above patch should be split in one
patch that is posted on the LIO mailing list and one patch that is
posted on the linux-scsi mailing list.

Bart.
