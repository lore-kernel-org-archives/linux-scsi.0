From: Roland Dreier <roland@purestorage.com>
Subject: Re: [LSF/MM TOPIC] Thin provisioning SOFT_THRESHOLD error handling
Date: Mon, 4 Feb 2013 16:06:32 -0800
Message-ID: <CAL1RGDUyv++VcY7UqBfYkfTc02voC0FbsxH50WF-n-qhkb6dLg@mail.gmail.com>
References: <510784DE.3000509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:51451 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754649Ab3BEAGy (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Mon, 4 Feb 2013 19:06:54 -0500
Received: by mail-wg0-f69.google.com with SMTP id fn15so7576964wgb.4
        for <Linux-scsi@vger.kernel.org>; Mon, 04 Feb 2013 16:06:53 -0800 (PST)
In-Reply-To: <510784DE.3000509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi <Linux-scsi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Tue, Jan 29, 2013 at 12:14 AM, Hannes Reinecke <hare@suse.de> wrote:
> I would like to discuss at LSF the possible implementations
> and handling mechanism for this kind of failure scenarios.

I'd be interested in that discussion.  With my Pure hat on, our array
can generate these thin provisioning threshold unit attentions, and it
would be nice if Linux did something intelligent with them.

 - R.
