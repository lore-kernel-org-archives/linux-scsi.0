From: "Bennie J. Venter" <Bennie.Venter@shoden.co.za>
Subject: RE: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Wed, 22 Jan 2003 14:07:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0A62368A12C5BC4080B2F8254680D454149E8F@shodenjhb02.shoden.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> That model cannot be applied to SCSI as it is much more diverse
> in the number of bus types it supports.
> USB can do it, because it knows about hubs. SCSI cannot,
> as there are no hubs in SCSI.

Not entirely true - there are devices known as bridges that bridge parallel SCSI to parallel SCSI and parallel SCSI to fiber channel.  Not to talk about fiber channel as a SCSI interface.

Tnx & Bi
Bennie Venter

