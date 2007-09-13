From: Mark Lord <lkml@rtr.ca>
Subject: Re: Problems with USB disk [solved]
Date: Thu, 13 Sep 2007 11:21:07 -0400
Message-ID: <46E95563.5020704@rtr.ca>
References: <Pine.LNX.4.44L0.0709131105250.3619-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0709131105250.3619-100000@iolanthe.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Niels <zorglub_olsen@hotmail.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Thu, 13 Sep 2007, Mark Lord wrote:
..
>> What happens is, there's a nice little LED on the Cruzer stick,
>> that is "lit" when the stick itself is not in a "power suspend" state
>> (or whatever you USB folks call it).
> 
> We call it "suspended".  (Wasn't there an episode of Classic Trek where 
> Mr. Spock explained to somebody, "I call them `ears'."?)
> 
>> On 2.6.22, that little LED stays "on" normally, and flickers off/on
>> when data is being transfered.
>>
>> The new "USB autosuspend" logic in 2.6.23 now causes that little LED
>> to turn off after a few seconds of inactivity.
>>
>> Once that happens, the USB stick is not accessible until after a longish
>> timeout (~30s I think), followed by a USB reset.  Then it is usable again
>> until the next inactivity timeout and autosuspend (a few seconds).
> 
> So this _isn't_ the regression described above -- to wit, that the 
> drive gets spun down and then won't work without first being spun back 
> up.  You wrote:
> 
>>>> My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.
> 
> But it doesn't.  It suffers from a different regression.

Perhaps, but that doesn't necessarily follow from the above.
>From this observer's point of view (and being an expert on disk technologies),
the same "spin up" issue for rotating media could be the culprit here too.

A reset to a disk drive usually (not always) causes it to spin up.

Regardless, Greg has acknowledged the regression and is planning to revert things.

Cheers

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
