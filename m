From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 16:22:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E49698D.3030402@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Luben Tuikov [luben@splentec.com] wrote:
> 
>>Yeah, the host_lock...
>>
>>I'm not very fond of grabbing a spin lock calling a fn which may sleep
>>and then releasing the lock...
> 
> 
> We grab this lock today before calling eh handlers, but I believe some
> LLDDs drop the lock if they are going to sleep.

:-)  yes, I know -- I was just saying that I don't like this policy
that much.

It's an oxymoronic to grab a spin lock and say to someone, ok
you can sleep, and then release the spin lock...

-- 
Luben


