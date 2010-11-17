From: Andre Tomt <andre@tomt.net>
Subject: Re: mvsas errors in 2.6.36
Date: Wed, 17 Nov 2010 09:24:14 +0100
Message-ID: <4CE3912E.6060904@tomt.net>
References: <201010290650.32892.thomas@fjellstrom.ca> <201010310911.45738.thomas@fjellstrom.ca> <201011170053.31174.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201011170053.31174.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/17/2010 08:53 AM, Thomas Fjellstrom wrote:
[snip]
> Still no fatal errors, but the problem is still happening regularly. It causes
> a pause in disk io of a couple seconds at least. Really quite annoying.
[snip]

After the mvsas update in 2.6.35 this started happening to me as well; 
at least its better than the previous state - not working.. ;-) However, 
after rolling a new 2.6.35 with the following fix that is queued up for 
the upcoming 2.6.35 and 2.6.36 stable releases, they seem to have 
dissapeared - 3 days and counting.

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=queue-2.6.33/libsas-fix-ncq-mixing-with-non-ncq.patch;h=b6d7c92094d95ad67a3b23c2e09c25d4fbd0f46b;hb=HEAD

The fix is queued up for the next 2.6.36 and 2.6.35 stable point-releases.
