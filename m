From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT
Date: Thu, 09 Oct 2014 12:49:20 +0200
Message-ID: <54366830.4050009@redhat.com>
References: <1412825695-15134-1-git-send-email-nab@daterainc.com> <1412828062.31947.50.camel@haakon3.risingtidesystems.com> <54364C2B.5000206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:54444 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaJIKtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2014 06:49:33 -0400
In-Reply-To: <54364C2B.5000206@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>

Il 09/10/2014 10:49, Paolo Bonzini ha scritto:
> 
> It does not happen if you close QEMU with SIGTERM, ctrl-c, or with the
> "quit" command, because no attempt is done to bring down the VM data
> structures (or free memory, or close file descriptors) in case of a
> fatal exit.  The kernel should do that for us.

... and in the case of vhost-scsi, doesn't it do that when
vhost_scsi_release calls vhost_scsi_clear_endpoint?

Paolo
