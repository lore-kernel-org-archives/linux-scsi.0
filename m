From: Steve deRosier <derosier@pianodisc.com>
Subject: Re: CDROMREADAUDIO ioctl EINVAL error with 2.6.1; it works with 2.4.21
Date: Mon, 02 Feb 2004 11:09:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401EA077.3080309@pianodisc.com>
References: <4019A35E.5050000@pianodisc.com> <20040130111105.GM11683@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip201.pianodisc.com ([207.173.133.201]:39036 "EHLO
	EXCHANGE01-Srv.pianodisc.com") by vger.kernel.org with ESMTP
	id S265750AbUBBTIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2004 14:08:21 -0500
In-Reply-To: <20040130111105.GM11683@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens,

Thanks.  I tried it out and it does indeed fix the problem.  Unfortunately it mucks up my timing calculations for my MIDI and audio output, but that's now a bug for me.  Thanks for the speedy help.

- Steve

