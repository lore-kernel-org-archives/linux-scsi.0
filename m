From: Andrew R Reid <andrew@cpplating.com.au>
Subject: Re: Problems with DLT tape drive.
Date: Wed, 29 May 2002 09:31:39 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ad148q$hlh$2@main.gmane.org>
References: <20020528153728.C14543@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020528153728.C14543@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-tape@vger.kernel.org, linux-scsi@vger.kernel.org

Thank you Doug.

I did what you sugessted and it works fine.  I will reconfigure my scsi
busses so that all the 25 pin scsi devices are on the same controller with
no other devices.

I suppose the reason I was having problems is that there is no termination
on the pins that arn't used in the 25 pin cables.  Should have thought of
that myself!

> For testing purposes you could install a terminator on the tape drive, 
> leaving the scanner and zip drive disconnected long enough to reboot the 
> machine and try a backup.  The SCSI bus layout you list is somewhat 
> questionable as far as reliability is concerned, and this test should 
> eliminate a lot of the possible variances that could result in bus errors.  
> Another option is to configure the BIOS on the 2930 card to only allow 
> async transfers to the tape drive.  That can help with bus errors on 
> questionable busses.
> 
> -- 
>   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>          Red Hat, Inc. 
>          1801 Varsity Dr.
>          Raleigh, NC 27606

Andrew Reid			C.P.Plating
Technical Sales Manager		P O Box 1335	   --------- /---    /---\
C. P. Plating Pty Ltd		222a Macathur Ave   ------- /       /    /
Mob:    +61 4 1474 9943		EAGLE FARM 4009      ----- /       /----/
Direct: +61 7 3260 3260		AUSTRALIA	      --- /       /
e-mail: andrew@cpplating.com.au	Phn: +61 7 3268 3044   - |---- o /   o
				Fax: +61 7 3268 3433

