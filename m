From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Task Sets in SCSI and Linux
Date: Wed, 8 May 2002 09:56:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0205080956260.58242-100000@beppo>
References: <Pine.BSF.4.21.0205080946300.58242-100000@beppo>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.BSF.4.21.0205080946300.58242-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Michael Heinz <mheinz@infiniconsys.com>, linux-scsi@vger.kernel.org

> 
> 	abort tag -> reset device -> reset bus
> 
> for each timed out command. Individual HBA drivers may or may not support
> this.

Sorry- I meant to say

"Individual HBA drivers may or may not support the finer grained level of task
manangement"


