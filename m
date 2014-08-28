From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 17:54:50 +0200
Message-ID: <53FF50CA.70209@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com> <53FF4709.9040801@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958C2A1D0@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaH1PzB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 11:55:01 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C2A1D0@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

Il 28/08/2014 17:50, Elliott, Robert (Server Storage) ha scritto:
> Is the block layer prevented from issuing a new command with the
> same tag before the error handling is finished?

Tags are chosen by the LLDs, so it's up to it to pick the right tags.

Paolo
